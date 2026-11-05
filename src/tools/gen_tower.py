"""妖塔的阶梯、竖井和分块崩塌的塔顶环台。"""

from gen_banquet_tomb import Scene


def tower():
    s = Scene(
        "tower",
        "deepslate_bricks",
        "cracked_deepslate_bricks",
        "塔影镇",
        "netherite_helmet",
    )
    s.stage(1, "塌陷楼梯 · 击倒挡路守卫，沿宽阶向上。")
    s.setup += ["fill ~1 ~ ~1 ~94 ~ ~30 air"]
    # 每四格只抬升一格，留下无须跳跃的石阶和可追赶的安全边道。
    for x in range(1, 64):
        y = min(x // 5, 12)
        s.setup += [f"fill ~{x} ~{y} ~10 ~{x} ~{y} ~20 deepslate_tiles"]
        if x % 5 == 0:
            s.setup += [
                f"fill ~{x - 1} ~{y} ~10 ~{x - 1} ~{y} ~20 polished_deepslate_stairs[facing=east]"
            ]
    s.setup += ["fill ~31 ~1 ~10 ~31 ~9 ~20 air", "fill ~63 ~7 ~10 ~63 ~18 ~20 air"]
    # 还原墙上的洞后重放交界阶面。
    s.setup += [
        "fill ~31 ~6 ~10 ~31 ~6 ~20 deepslate_tiles",
        "fill ~63 ~12 ~10 ~63 ~12 ~20 deepslate_tiles",
    ]
    s.stages[1] += [
        'summon husk ~18 ~4 ~15 {Tags:["dm_scene_tower","ds_guard_tower","monster"],DeathLootTable:"minecraft:empty",PersistenceRequired:1b}'
    ]
    s.stage(2, "断塔竖井 · 裂纹后方会崩塌，贴南侧窄边可追赶。")
    s.stage(3, "塔顶环台 · 击败塔影。裂纹预告下一块崩塌位置。")
    s.tick += [
        "execute if score #tower ds_stage matches 1 unless entity @e[tag=ds_guard_tower] positioned ~28 ~5 ~10 if entity @a[tag=plm_d_tower,dx=5,dy=5,dz=10] at @s run function plm:domains/tower/stage/2",
        "execute if score #tower ds_stage matches 2 positioned ~60 ~11 ~10 if entity @a[tag=plm_d_tower,dx=4,dy=4,dz=10] at @s run function plm:domains/tower/stage/3",
    ]
    for left in range(5, 56, 5):
        y = left // 5
        s.tick += [
            f"execute positioned ~{left + 5} ~{y + 1} ~9 if entity @a[tag=plm_d_tower,dx=3,dy=4,dz=12] if block ~-4 ~-1 ~3 deepslate_tiles run particle falling_dust gravel ~-3 ~ ~5 1 0.2 1 0 4",
            f"execute positioned ~{left + 10} ~{y + 2} ~9 if entity @a[tag=plm_d_tower,dx=3,dy=4,dz=12] run fill ~-10 ~-2 ~1 ~-6 ~-2 ~9 air",
        ]
    for lo, hi, mat in [
        (0, 30, "deepslate_tiles"),
        (4, 26, "polished_deepslate"),
        (9, 21, "quartz_bricks"),
    ]:
        s.setup += [f"fill ~{64 + lo} ~12 ~{lo} ~{64 + hi} ~12 ~{hi} {mat}"]
    s.boss(3, 80, 15, 13)
    s.stages[3] += [
        "scoreboard players set #tower ds_window 36000",
        "scoreboard players set #tower ds_hold 0",
        "scoreboard players set #tower ds_seq 0",
    ]
    # 切开外中圈的八条边和中央逐层收缩的三圈，最后消失前有十五秒输出。
    rects = [
        (64, 0, 67, 30),
        (68, 0, 90, 3),
        (91, 0, 94, 30),
        (68, 27, 90, 30),
        (68, 4, 72, 26),
        (73, 4, 85, 8),
        (86, 4, 90, 26),
        (73, 22, 85, 26),
    ]
    s.write(
        "crumble",
        [
            f"execute if score #tower ds_seq matches {i} run fill ~{x} ~12 ~{z} ~{u} ~12 ~{v} air"
            for i, (x, z, u, v) in enumerate(rects)
        ]
        + [
            f"execute if score #tower ds_seq matches {i} run fill ~{64 + l} ~12 ~{l} ~{64 + h} ~12 ~{h} air outline"
            for i, l, h in [
                (8, 9, 21),
                (9, 10, 20),
                (10, 11, 19),
                (11, 12, 18),
                (12, 13, 17),
            ]
        ]
        + [
            "scoreboard players add #tower ds_seq 1",
            "scoreboard players set #tower ds_hold 0",
        ],
    )
    s.write(
        "warn",
        [
            f"execute if score #tower ds_seq matches {i} run particle block cracked_deepslate_bricks ~{(x + u) // 2} ~13 ~{(z + v) // 2} {(u - x) / 3:.1f} 0.2 {(v - z) / 3:.1f} 0 48"
            for i, (x, z, u, v) in enumerate(rects)
        ]
        + [
            'title @a[tag=plm_d_tower] actionbar {"text":"塔影举臂 · 离开裂纹，移向内圈"}'
        ],
    )
    s.tick += [
        "execute if score #tower ds_stage matches 3 run function plm:domains/tower/boss_tick"
    ]
    s.write(
        "boss_tick",
        [
            "scoreboard players add #tower ds_hold 1",
            "execute if score #tower ds_hold matches 1 run function plm:domains/tower/warn",
            "execute if score #tower ds_hold matches 40 positioned ~80 ~13 ~15 as @a[tag=plm_d_tower,distance=..3] run damage @s 4 minecraft:mob_attack",
            "scoreboard players operation #pct ds_hp = #tower ds_hp",
            "scoreboard players operation #pct ds_hp *= #100 ds_hp",
            "scoreboard players operation #pct ds_hp /= #tower ds_max",
            "execute if score #tower ds_seq matches 0..3 if score #tower ds_hold matches 240.. run function plm:domains/tower/crumble",
            "execute if score #pct ds_hp matches ..70 if score #tower ds_seq matches 4..7 if score #tower ds_hold matches 160.. run function plm:domains/tower/crumble",
            "execute if score #pct ds_hp matches ..35 if score #tower ds_seq matches 8.. if score #tower ds_hold matches 300.. run function plm:domains/tower/crumble",
            "execute if score #tower ds_seq matches 13.. if score #tower ds_hp matches 1.. run function plm:domains/tower/abort",
        ],
    )
    s.finish()
    s.write(
        "checkpoint",
        [
            f"execute if score #tower ds_stage matches {n} run tp @a[tag=plm_rescue,tag=plm_d_tower] ~{x}.5 ~{y} ~{z}.5 -90 0"
            for n, x, y, z in [(1, 3, 1, 20), (2, 34, 7, 20), (3, 79, 13, 15)]
        ],
    )


if __name__ == "__main__":
    tower()
