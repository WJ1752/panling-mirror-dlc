"""在空闲的本机隔离服验证制作、洗练、真实交互及五域结算。详见五域验证工作流。"""

import argparse
import json
import os
import re
import subprocess
import sys
import tempfile
import time
import uuid
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT / ".work/tools"))
import rcon

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument(
    "--server", type=Path, required=True, help="已启动的、可丢弃的隔离服目录"
)
parser.add_argument(
    "--only",
    nargs="+",
    choices=["bench", "fire", "tomb", "tower", "valley", "mountain"],
    default=["bench", "fire", "tomb", "tower", "valley", "mountain"],
)
args = parser.parse_args()
server = args.server.resolve()
properties = dict(
    line.split("=", 1)
    for line in (server / "server.properties").read_text(encoding="utf-8").splitlines()
    if line and not line.startswith("#") and "=" in line
)
if (
    server == (ROOT / "梦回盘灵服务端").resolve()
    or properties.get("server-ip") != "127.0.0.1"
    or properties.get("online-mode") != "false"
):
    parser.error("需要明确绑定 127.0.0.1 的离线隔离服。")
scratch = tempfile.TemporaryDirectory(prefix="panling-domain-qa-")
q = Path(scratch.name)
sock = rcon.connect(
    "127.0.0.1", int(properties["rcon.port"]), properties["rcon.password"]
)
rcon.IDLE = 0.01
P = "MirrorPilot"
D = "execute in plm:domains run "
POS = {
    "fire": (-309, 11, 801),
    "tomb": (606, 10, -130),
    "tower": (-195, 65, -180),
    "valley": (-690, 108, -637),
    "mountain": (-177, 99, -831),
}
I = {d: i for i, d in enumerate(POS, 1)}


def cmd(c):
    return rcon.command(sock, c, 4)


def ok(v, msg):
    if not v:
        raise RuntimeError(msg)


def test(c):
    v = cmd(c)
    ok("Test passed" in v, c + " => " + v)


def score(p, k):
    v = cmd(f"scoreboard players get {p} {k}")
    m = re.search(r"has (-?\d+)", v)
    return int(m[1]) if m else -999


def wait(fn, msg, sec=5):
    end = time.time() + sec
    while time.time() < end:
        if fn():
            return
        time.sleep(0.08)
    raise RuntimeError(msg)


def pos(tag, dim="plm:domains"):
    v = cmd(f"execute in {dim} run data get entity @e[tag={tag},limit=1] Pos")
    arr = re.search(r"\[([-\d., d]+)\]", v)
    ok(arr, v + " " + tag)
    return [float(x.rstrip("d")) for x in arr[1].split(", ")]


def action(tag, mode="click", dim="plm:domains"):
    x, y, z = pos(tag, dim)
    cmd(f"execute in {dim} run tp {P} {x} {y} {z - 1.85}")
    time.sleep(0.18)
    req = dict(id=str(uuid.uuid4()), x=x, y=y, z=z, mode=mode)
    (q / "domains-action.tmp").write_text(json.dumps(req))
    os.replace(q / "domains-action.tmp", q / "domains-action.json")

    def reply():
        try:
            r = json.loads((q / "domains-response.json").read_text())
        except (ValueError, FileNotFoundError):
            return False
        if r["id"] != req["id"]:
            return False
        ok(r.get("ok"), str(r))
        return True

    wait(reply, "client did not answer " + tag, 8)
    time.sleep(0.16)


def gate(d):
    x, y, z = POS[d]
    cmd(f"execute in minecraft:overworld run tp {P} {x} {y} {z - 2}")
    time.sleep(0.7)
    cmd(f"execute in minecraft:overworld run setblock {x} {y - 1} {z - 2} stone keep")
    action("plm_gate_map_" + d, dim="minecraft:overworld")
    wait(
        lambda: "plm:domains" in cmd(f"data get entity {P} Dimension"),
        "map gate failed",
    )
    print("portal", d, flush=True)


def stage(d, n):
    wait(
        lambda: score("#" + d, "ds_stage") == n,
        f"{d} expected stage {n}, saw " + str(score("#" + d, "ds_stage")),
    )


def join(d):
    gate(d)
    action("plm_gate_join_" + d)
    wait(lambda: score("#" + d, "dm_state") == 2, "admission failed " + d, 15)
    stage(d, 1)


def bench():
    gate("fire")
    cmd(D + "data modify block 14 64 6 Items set value []")
    recipe = [
        (0, "amethyst_shard", "heart_fire", 2),
        (1, "netherite_scrap", "shard_fire", 2),
        (2, "quartz", "edge_zhao", 1),
        (3, "charcoal", "mold_helmet", 1),
        (8, "gunpowder", "dust", 20),
    ]

    def put(slot, item, key, n):
        cmd(
            D
            + f'item replace block 14 64 6 container.{slot} with minecraft:{item}{{id:"panling:mirror_{key}"}} {n}'
        )

    for row in recipe:
        put(*row)
    action("plm_gate_work")
    check = D + "execute if data block 14 64 6 Items[{Slot:5b,tag:{is_armor:1}}]"
    test(check)
    time.sleep(0.6)
    action("plm_gate_work")
    test(check)
    cmd(D + "item replace block 14 64 6 container.3 from block 14 64 6 container.5")
    cmd(D + "item replace block 14 64 6 container.5 with air")
    put(0, "glowstone_dust", "sand", 1)
    put(8, "gunpowder", "dust", 10)
    time.sleep(0.6)
    action("plm_gate_work")
    test(check)
    test(
        D
        + "execute unless data block 14 64 6 Items[{Slot:0b}] unless data block 14 64 6 Items[{Slot:8b}]"
    )
    test(D + "execute if data block 14 64 6 Items[{Slot:5b}].tag.mirror_line1")
    cmd(D + f"item replace entity {P} armor.head from block 14 64 6 container.5")
    cmd(D + "item replace block 14 64 6 container.5 with air")
    print("CRAFT → occupied output → POLISH → EQUIP PASS", flush=True)


def strike(d, n=1):
    for _ in range(n):
        if score("#" + d, "dm_state") != 2:
            return
        cmd(D + f"damage @e[tag=dm_boss_{d},limit=1] 32 minecraft:player_attack by {P}")
        time.sleep(0.53)


def warp(d, x, y, z):
    cmd(D + f"tp {P} {256 * I[d] + x + 0.5} {64 + y} {z + 0.5}")
    time.sleep(0.17)


def run(d):
    join(d)
    if d == "fire":
        for n, count in [(1, 3), (2, 5), (3, 3)]:
            for i in range(count):
                action(f"ds_fire_jar{n}_{i}", "attack")
            stage(d, n + 1)
        first = True
        for _ in range(14):
            if score("#fire", "dm_state") != 2:
                break

            def ready():
                return any(
                    "entity data"
                    in cmd(D + f"data get entity @e[tag=ds_fire_offer_{j},limit=1] Pos")
                    for j in range(3)
                )

            wait(ready, "offer not refreshed", 24)
            j = next(
                j
                for j in range(3)
                if "entity data"
                in cmd(D + f"data get entity @e[tag=ds_fire_offer_{j},limit=1] Pos")
            )
            action("ds_fire_offer_" + str(j), "attack")
            if score("#fire", "ds_window") > 0:
                if first:
                    cmd(f"item replace entity {P} weapon.mainhand with diamond_sword")
                    before = score("#fire", "ds_hp")
                    action("dm_boss_fire", "boss")
                    wait(
                        lambda: score("#fire", "ds_hp") < before,
                        "physical sword strike failed",
                    )
                    print(
                        "physical sword hit",
                        before,
                        "→",
                        score("#fire", "ds_hp"),
                        flush=True,
                    )
                    first = False
                strike(d, 6)
    elif d == "tomb":
        for n, count in [(1, 3), (2, 3), (3, 4)]:
            action("ds_tomb_box" + str(n))
            for i in range(count):
                action(f"ds_tomb_lamp{n}_{i}")
            stage(d, n + 1)
        # 引怪至棺角灯，最后一窗按真实十秒计时。
        warp(d, 85, 1, 10)
        wait(lambda: score("#tomb", "ds_window") > 0, "boss outside lamplight", 20)
        for _ in range(35):
            if score("#tomb", "dm_state") != 2:
                break
            if score("#tomb", "ds_seq") == 2 and score("#tomb", "ds_window") <= 0:
                for i in range(4):
                    action(f"ds_tomb_flame{i}")
                wait(lambda: score("#tomb", "ds_window") > 0, "four lamps failed", 15)
            strike(d, 1)
    elif d == "tower":
        cmd(
            D
            + f"damage @e[tag=ds_guard_tower,limit=1] 200 minecraft:player_attack by {P}"
        )
        time.sleep(1.2)
        warp(d, 29, 6, 15)
        stage(d, 2)
        warp(d, 61, 13, 15)
        stage(d, 3)
        strike(d, 16)
    elif d == "valley":
        action("ds_valley_first")
        stage(d, 2)
        for _ in range(3):
            action("ds_valley_altar")
            action("ds_practice_valley", "attack")
        stage(d, 3)
        for i in range(3):
            action(f"ds_valley_pool{i}")
        stage(d, 4)
        strike(d, 9)
        wait(lambda: score("#valley", "ds_hold") == 2, "main gate not required")
        action("ds_valley_main")
        strike(d, 8)
    elif d == "mountain":
        pads = [(9, 0), (0, 9), (-9, 0), (0, -9)]

        def pad(cx, i):
            warp(d, cx, 1, 15)
            dx, dz = pads[i]
            warp(d, cx + dx, 1, 15 + dz)

        pad(16, 0)
        stage(d, 2)
        pad(48, 2)
        pad(48, 3)
        stage(d, 3)
        for i in range(4):
            pad(80, i)
        stage(d, 4)
        for _ in range(4):
            if score("#mountain", "ds_hold") == 2:
                break
            pad(80, score("#mountain", "ds_seq"))
            strike(d, 4)
        for i in range(4):
            pad(80, i)
        strike(d, 8)
    wait(lambda: score("#" + d, "dm_state") == 0, "no win " + d)
    ok(score(P, "dm_paid") == score(P, "dm_run"), "this run has no reward receipt")
    ok(score(P, "dm_max_" + d) >= 2, "missing progress " + d)
    test(f"execute if entity @a[name={P},tag=plm_clear_{d},tag=!plm_enrolled]")
    print(d, "WIN, personal depth, return & release PASS", flush=True)


# 测试会摆放隔离服的入口脚垫、操作重华台容器，并传送专用测试玩家。
if not re.search(r"There are 0 of", cmd("list")) or score("#slots", "dm_party") > 0:
    parser.error("隔离服必须无人在线且没有正在运行的镜域。")
env = os.environ.copy()
env["NODE_PATH"] = str(ROOT / ".work/bottools/node_modules")
client = subprocess.Popen(
    ["node", str(Path(__file__).with_name("client.cjs")), properties["server-port"]],
    cwd=q,
    env=env,
)
try:
    wait(lambda: "MirrorPilot" in cmd("list"), "Test client could not join", 20)
    cmd("gamemode creative MirrorPilot")
    for task in args.only:
        if task == "bench":
            bench()
        else:
            run(task)
finally:
    client.terminate()
    client.wait(timeout=10)
    sock.close()
    scratch.cleanup()
