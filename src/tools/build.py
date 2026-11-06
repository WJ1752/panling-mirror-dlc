# -*- coding: utf-8 -*-
"""
build —— 《梦回盘灵：镜中倒影》打包工具

功能：
  1. 打数据包  dist/panling-mirror-<ver>.zip
  2. 打资源包  （= 本体 RP + src/resourcepack 追加，保证服务器只下发一个包）
  3. 计算 sha1 并写出 dist/manifest.json
  4. 可选部署到测试服（--deploy-test）或正式服（--deploy-prod，需 --yes）
  5. 可选跑 lint（--lint）

用法：
  python src/tools/build.py --ver 1.0.0-alpha.1
  python src/tools/build.py --ver 1.0.0-alpha.1 --deploy-test
  python src/tools/build.py --ver 1.0.0 --deploy-prod --yes
  python src/tools/build.py --lint-only
"""
import argparse
import hashlib
import io
import json
import os
import shutil
import subprocess
import sys
import zipfile

sys.stdout.reconfigure(encoding='utf-8', errors='replace')

SRC = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))     # src/
PROJ = os.path.dirname(SRC)
DP = os.path.join(SRC, 'datapack')
RP = os.path.join(SRC, 'resourcepack')
DIST = os.path.join(PROJ, 'dist')

BASE_RP = os.path.join(PROJ, '梦回盘灵服务端', 'resourcepack', 'panling-1.20-resourcepack-1.1.0b.zip')
BASE_DP_ZIP = os.path.join(PROJ, '梦回盘灵服务端', 'world', 'datapacks', 'panling-1.1.0b.zip')

TEST_DIR = os.path.join(PROJ, '.work', 'weapon-test', 'server')
TEST_WORLD_DP = os.path.join(TEST_DIR, 'world_weapon', 'datapacks')
TEST_RP_DIR = os.path.join(TEST_DIR, 'resourcepack')
PROD_DIR = os.path.join(PROJ, '梦回盘灵服务端')
PROD_WORLD_DP = os.path.join(PROD_DIR, 'world', 'datapacks')
PROD_RP_DIR = os.path.join(PROD_DIR, 'resourcepack')
PROD_BACKUP_DIR = os.path.join(PROJ, 'backups')


def sha1_of(path):
    h = hashlib.sha1()
    with open(path, 'rb') as f:
        for chunk in iter(lambda: f.read(1 << 20), b''):
            h.update(chunk)
    return h.hexdigest()


MERGE_MARKER = '__merge_with_base__'


def find_merge_patches(src):
    """扫描 src 里的 JSON，返回 {相对路径: patch 对象}（只认 __merge_with_base__: true）。

    合并补丁只允许包含标记键与 overrides；parent/textures/display 等一律以本体为权威。
    """
    patches = {}
    for dp, dn, fn in os.walk(src):
        for f in fn:
            if not f.endswith('.json'):
                continue
            full = os.path.join(dp, f)
            try:
                with io.open(full, encoding='utf-8') as fh:
                    obj = json.load(fh)
            except Exception:
                continue
            if not isinstance(obj, dict) or obj.get(MERGE_MARKER) is not True:
                continue
            rel = os.path.relpath(full, src).replace(os.sep, '/')
            extra = set(obj) - {MERGE_MARKER, 'overrides'}
            if extra:
                raise SystemExit('%s：合并补丁只允许 %s/overrides，多出 %s'
                                 % (rel, MERGE_MARKER, sorted(extra)))
            if not isinstance(obj.get('overrides'), list):
                raise SystemExit('%s：合并补丁缺少 overrides 数组' % rel)
            patches[rel] = obj
    return patches


def merge_with_base(rel, base_obj, patch_obj):
    """本体字段打底，overrides = 本体在前 + 我们的在后。"""
    if not isinstance(base_obj, dict):
        raise SystemExit('%s：本体同名 JSON 不是对象，无法合并' % rel)
    merged = dict(base_obj)
    merged['overrides'] = list(base_obj.get('overrides', [])) + list(patch_obj.get('overrides', []))
    return merged


def zip_dir(src, out_zip, extra_from=None, skip_pred=None):
    """把 src 目录打包；extra_from 为额外叠加的 (zip 路径) —— 冲突时以 src 为准。

    src 中带 __merge_with_base__ 标记的 JSON 会读 extra_from 同名 JSON，
    输出「本体字段 + 本体 overrides + 我们 overrides」，并从产物中去掉标记键。
    """
    written = set()
    patches = find_merge_patches(src)
    base = zipfile.ZipFile(extra_from) if (extra_from and os.path.exists(extra_from)) else None
    try:
        with zipfile.ZipFile(out_zip, 'w', zipfile.ZIP_DEFLATED) as z:
            for dp, dn, fn in os.walk(src):
                for f in fn:
                    full = os.path.join(dp, f)
                    rel = os.path.relpath(full, src).replace(os.sep, '/')
                    if skip_pred and skip_pred(rel):
                        continue
                    if rel in patches:
                        if base is None:
                            raise SystemExit('%s 是合并补丁，但未提供本体资源包' % rel)
                        try:
                            base_obj = json.loads(base.read(rel).decode('utf-8'))
                        except KeyError:
                            raise SystemExit('%s 是合并补丁，但本体资源包里没有同名文件' % rel)
                        merged = merge_with_base(rel, base_obj, patches[rel])
                        # 固定时间戳：补丁内容只取决于本体 + manifest，避免每次构建 sha1 漂移
                        info = zipfile.ZipInfo(rel, (1980, 1, 1, 0, 0, 0))
                        info.compress_type = zipfile.ZIP_DEFLATED
                        info.external_attr = 0o644 << 16
                        z.writestr(info, json.dumps(merged, ensure_ascii=False, indent=2))
                    else:
                        z.write(full, rel)
                    written.add(rel)
            added = 0
            if base:
                for info in base.infolist():
                    if info.is_dir() or info.filename in written:
                        continue
                    z.writestr(info, base.read(info.filename))
                    added += 1
    finally:
        if base:
            base.close()
    return written, added


def skip_meta(rel):
    """跳过 .zcode/.git/.vscode 等元数据目录与 __pycache__，避免把工具产物打进包里。
    同时跳过包根目录下的 src/（cwd 兼容转发器放在那里，不属于资源包内容）。"""
    parts = rel.split('/')
    if parts and parts[0] == 'src':
        return True
    return any(p.startswith('.') for p in parts) or '__pycache__' in parts


def build_datapack(ver):
    if not os.path.isdir(DP):
        raise SystemExit('数据包目录不存在: %s' % DP)
    # 校验 pack.mcmeta
    mcmeta = os.path.join(DP, 'pack.mcmeta')
    if not os.path.exists(mcmeta):
        raise SystemExit('缺少 src/datapack/pack.mcmeta')
    out = os.path.join(DIST, 'panling-mirror-%s.zip' % ver)
    files, _ = zip_dir(DP, out, skip_pred=skip_meta)
    return out, len(files)


def build_resourcepack(ver):
    if not os.path.exists(BASE_RP):
        raise SystemExit('找不到本体资源包: %s' % BASE_RP)
    out = os.path.join(DIST, 'panling-mirror-resourcepack-%s.zip' % ver)
    files, added = zip_dir(RP, out, extra_from=BASE_RP, skip_pred=skip_meta)
    return out, len(files) + added


def lint():
    tool = os.path.join(SRC, 'tools', 'pack_lint.py')
    print('── lint ──')
    rc = subprocess.call([sys.executable, '-I', tool])
    return rc == 0


def deploy_test(dp_zip, rp_zip, test_dp_dir=None, pack_name='panling-mirror-weapon-test.zip',
                test_rp_dir=None):
    target = test_dp_dir or TEST_WORLD_DP
    rp_target = test_rp_dir or TEST_RP_DIR
    os.makedirs(target, exist_ok=True)
    for old in os.listdir(target):
        # 保留 .bak. 备份；只删当前 mirror 包
        if old.startswith('panling-mirror-') and old.endswith('.zip') and '.bak.' not in old:
            os.remove(os.path.join(target, old))
    shutil.copyfile(dp_zip, os.path.join(target, pack_name))
    os.makedirs(rp_target, exist_ok=True)
    shutil.copyfile(rp_zip, os.path.join(rp_target, os.path.basename(rp_zip)))
    print('已部署到测试服目录：')
    print('  DP → %s' % os.path.join(target, pack_name))
    print('  RP → %s' % os.path.join(rp_target, os.path.basename(rp_zip)))
    print('下一步：RCON `reload`（或重启 25590），并确认 datapack list 只有 base + 1 个 mirror 包。')
    print('注意：测试服资源包 URL/sha1 若走 HTTP，需同步 server.properties。')


def backup_prod(prod_dir, backup_dir=None):
    """完整备份 world/ + server.properties；返回备份目录。"""
    stamp = __import__('datetime').datetime.now().strftime('%Y%m%d-%H%M%S')
    root = os.path.join(backup_dir or PROD_BACKUP_DIR, 'mirror-%s' % stamp)
    os.makedirs(root, exist_ok=True)
    world = os.path.join(prod_dir, 'world')
    if not os.path.isdir(world):
        raise SystemExit('正式服 world 目录不存在，无法备份: %s' % world)
    world_zip = os.path.join(root, 'world.zip')
    with zipfile.ZipFile(world_zip, 'w', zipfile.ZIP_DEFLATED) as z:
        for dp, dn, fn in os.walk(world):
            for f in fn:
                full = os.path.join(dp, f)
                rel = os.path.relpath(full, prod_dir).replace(os.sep, '/')
                z.write(full, rel)
    props = os.path.join(prod_dir, 'server.properties')
    if os.path.exists(props):
        shutil.copyfile(props, os.path.join(root, 'server.properties'))
    print('已备份：%s' % root)
    return root


def deploy_prod(dp_zip, rp_zip, rp_sha1, prod_dir=None, backup_dir=None, server_stopped=False,
                install_shadow_map=False):
    """安全部署：

    必须显式声明服务器已停服；先完整备份 world/ + server.properties；
    删除旧 mirror 包后再复制新包，避免同服出现两个 mirror 数据包。
    部署后仍需人工/脚本启动并检查 `datapack list`/`Done`/0 玩家。
    """
    if not server_stopped:
        raise SystemExit(
            '拒绝部署：正式服必须先在游戏内 save-all flush + stop，并确认进程已退出；'
            '然后加 --server-stopped 重跑；启动与验证仍需人工完成。')
    root = prod_dir or PROD_DIR
    world_dp = os.path.join(root, 'world', 'datapacks')
    rp_dir = os.path.join(root, 'resourcepack')
    if not os.path.isdir(world_dp):
        raise SystemExit('正式服 datapacks 目录不存在: %s' % world_dp)
    props = os.path.join(root, 'server.properties')
    if os.path.exists(props):
        lines = io.open(props, encoding='utf-8', errors='replace').read().splitlines()
        rp_url = next((l.split('=', 1)[1] for l in lines if l.startswith('resource-pack=')), '')
        if '://' not in rp_url.replace('\\:', ':') or '/' not in rp_url.split('//', 1)[-1]:
            raise SystemExit('请先在 server.properties 配置完整的 resource-pack 文件 URL。')
    snapshot = backup_prod(root, backup_dir)
    if install_shadow_map:
        # Reuse the cold-backup/deployment transaction for the adjacent world
        # patch. The generator preserves original chunks and checks session.lock.
        world = os.path.join(root, 'world')
        subprocess.run([
            sys.executable, '-X', 'utf8', '-I', os.path.join(SRC, 'tools', 'gen_shadow_map.py'),
            '--source-world', world, '--target-world', world,
            '--backup-dir', os.path.join(snapshot, 'shadow-regions'), '--apply',
        ], check=True)
        # The legacy launcher otherwise resets the URL back to the base pack.
        updater = os.path.join(root, 'tools', 'update-pack-url.ps1')
        os.makedirs(os.path.dirname(updater), exist_ok=True)
        if os.path.isfile(updater):
            shutil.copyfile(updater, os.path.join(snapshot, 'update-pack-url.ps1'))
        shutil.copyfile(os.path.join(SRC, 'tools', 'update_pack_url.ps1'), updater)

    for old in os.listdir(world_dp):
        if old.startswith('panling-mirror-') and old.endswith('.zip') and '.bak.' not in old:
            os.remove(os.path.join(world_dp, old))
            print('已删除旧 mirror 包: %s' % old)
    shutil.copyfile(dp_zip, os.path.join(world_dp, os.path.basename(dp_zip)))
    os.makedirs(rp_dir, exist_ok=True)
    shutil.copyfile(rp_zip, os.path.join(rp_dir, os.path.basename(rp_zip)))

    if os.path.exists(props):
        out = []
        for l in lines:
            if l.startswith('resource-pack='):
                out.append('resource-pack=%s/%s' % (rp_url.rsplit('/', 1)[0], os.path.basename(rp_zip)))
            elif l.startswith('resource-pack-sha1='):
                out.append('resource-pack-sha1=%s' % rp_sha1)
            else:
                out.append(l)
        io.open(props, 'w', encoding='utf-8', newline='\n').write('\n'.join(out) + '\n')
    print('已部署到正式服目录并更新 resource-pack / sha1。')
    print('必须人工验证：datapack list 只有 base + 1 个 mirror；Done 无 Failed to load function/'
          'Unknown function/datapack error；0 玩家；status ping 正常。')
    print('回滚：停服后用备份目录的 world.zip/server.properties 恢复，并删除本次新包。')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--ver', default='1.0.0-alpha.1')
    ap.add_argument('--lint-only', action='store_true')
    ap.add_argument('--no-lint', action='store_true')
    ap.add_argument('--deploy-test', action='store_true')
    ap.add_argument('--deploy-test-dir', default=None,
                    help='测试服 datapacks 目录（默认 .work/weapon-test/server/world_weapon/datapacks）')
    ap.add_argument('--test-pack-name', default='panling-mirror-weapon-test.zip',
                    help='测试服数据包文件名（默认 panling-mirror-weapon-test.zip）')
    ap.add_argument('--test-rp-dir', default=None,
                    help='测试服资源包目录（默认 .work/weapon-test/server/resourcepack）')
    ap.add_argument('--deploy-prod', action='store_true')
    ap.add_argument('--server-stopped', action='store_true',
                    help='确认正式服已 save-all flush + stop 且进程退出；缺少此参数时 deploy-prod 拒绝执行')
    ap.add_argument('--prod-dir', default=None, help='正式服目录（默认 梦回盘灵服务端）')
    ap.add_argument('--backup-dir', default=None, help='备份目录（默认 backups/）')
    ap.add_argument('--install-shadow-map', action='store_true',
                    help='随停服正式部署安装圣山西侧影域地图，并保留启动器的合并资源包设置')
    ap.add_argument('--yes', action='store_true', help='正式服部署二次确认')
    args = ap.parse_args()

    if args.lint_only:
        sys.exit(0 if lint() else 1)

    if args.deploy_prod and not args.yes:
        print('\n✗ 正式服部署需要 --yes 确认')
        sys.exit(1)
    if args.deploy_prod and not args.server_stopped:
        print('\n✗ 拒绝部署：正式服必须先在游戏内 save-all flush + stop，并确认进程已退出；'
              '然后加 --server-stopped 重跑。')
        sys.exit(1)
    if args.install_shadow_map and not args.deploy_prod:
        ap.error('--install-shadow-map 必须与 --deploy-prod --server-stopped 一起使用')

    os.makedirs(DIST, exist_ok=True)

    if not args.no_lint and not lint():
        print('\n✗ lint 未通过，已中止打包（加 --no-lint 可跳过）')
        sys.exit(1)

    print('\n── build ──')
    dp_zip, dp_n = build_datapack(args.ver)
    print('数据包: %s（%d 个文件，%.1f KB）' % (os.path.basename(dp_zip), dp_n, os.path.getsize(dp_zip) / 1024))
    rp_zip, rp_n = build_resourcepack(args.ver)
    print('资源包: %s（%d 个文件，%.1f MB）' % (os.path.basename(rp_zip), rp_n, os.path.getsize(rp_zip) / 1048576))
    dp_sha, rp_sha = sha1_of(dp_zip), sha1_of(rp_zip)
    manifest = {
        'version': args.ver,
        'datapack': {'file': os.path.basename(dp_zip), 'sha1': dp_sha, 'files': dp_n},
        'resourcepack': {'file': os.path.basename(rp_zip), 'sha1': rp_sha, 'files': rp_n},
        'base_resourcepack': {'file': os.path.basename(BASE_RP), 'sha1': sha1_of(BASE_RP)},
        'built_at': __import__('datetime').datetime.now().isoformat(timespec='seconds'),
    }
    io.open(os.path.join(DIST, 'manifest.json'), 'w', encoding='utf-8', newline='\n').write(
        json.dumps(manifest, ensure_ascii=False, indent=2))
    print('sha1  dp=%s' % dp_sha)
    print('sha1  rp=%s' % rp_sha)
    print('manifest: dist/manifest.json')

    if args.deploy_test:
        print('\n── deploy-test ──')
        deploy_test(dp_zip, rp_zip, test_dp_dir=args.deploy_test_dir,
                    pack_name=args.test_pack_name, test_rp_dir=args.test_rp_dir)
    if args.deploy_prod:
        if not args.yes:
            print('\n✗ 正式服部署需要 --yes 确认')
            sys.exit(1)
        print('\n── deploy-prod ──')
        deploy_prod(dp_zip, rp_zip, rp_sha, prod_dir=args.prod_dir,
                    backup_dir=args.backup_dir, server_stopped=args.server_stopped,
                    install_shadow_map=args.install_shadow_map)
    print('\n✓ 完成')


if __name__ == '__main__':
    main()
