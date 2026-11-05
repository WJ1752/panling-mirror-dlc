"""四象祭坛的踏入边沿与共享剥形顺序。"""

from gen_banquet_tomb import Scene, label


def mountain():
    s = Scene(
        "mountain", "stone_bricks", "mossy_stone_bricks", "四圣兽映主", "dragon_head"
    )
    beasts = [
        ("青龙", "prismarine_bricks", "dragon_head", 9, 0),
        ("白虎", "quartz_pillar", "skeleton_skull", -9, 0),
        ("朱雀", "red_nether_bricks", "red_banner", 0, 9),
        ("玄武", "polished_blackstone", "turtle_helmet", 0, -9),
    ]
    sequence = [0, 2, 1, 3]
    for n, (center, goal) in enumerate([(16, 1), (48, 2), (80, 4)], 1):
        s.stage(
            n,
            [
                "",
                "四象台 · 踩青龙坛剥去第一层。",
                "双象台 · 沿光柱踩两坛，避开候场兽的预警。",
                "圣山顶 · 循地纹依次踏过四座祭坛。",
            ][n],
        )
        for j, (beast, block, head, dx, dz) in enumerate(beasts):
            x, z = center + dx, 15 + dz
            s.setup += [
                f"fill ~{x - 1} ~ ~{z - 1} ~{x + 1} ~ ~{z + 1} {block}",
                f"""summon text_display ~{x}.5 ~2 ~{z}.5 {{Tags:["{s.owned}"],billboard:"center",alignment:"center",text:'{label(beast)}'}}""",
            ]
        s.next(n, goal)
    s.stage(4, "四兽附身 · 踩亮坛后击打显形的映主。错坛回血；最后依次剥去四形。")
    s.boss(4)
    # 在域 marker 原点判断踏入，玩家必须走出四坛后才可再次触发。
    s.tick += [
        "scoreboard players operation #before ds_stage = #mountain ds_stage",
        "scoreboard players operation #need ds_seq = #mountain ds_count",
        "execute if score #mountain ds_stage matches 2 run scoreboard players add #need ds_seq 2",
        "execute if score #mountain ds_stage matches 4 if score #mountain ds_hold matches ..1 run scoreboard players operation #need ds_seq = #mountain ds_seq",
        "scoreboard players operation #need ds_seq %= #four ds_seq",
        "tag @a[tag=plm_d_mountain] remove ds_on_altar",
        "scoreboard players set #stepped ds_count 0",
    ]
    for n, center in [(1, 16), (2, 48), (3, 80), (4, 80)]:
        for j, (beast, block, head, dx, dz) in enumerate(beasts):
            x, z = center + dx, 15 + dz
            idx = sequence.index(j)
            prefix = f"execute if score #before ds_stage matches {n} positioned ~{x - 1} ~1 ~{z - 1}"
            zone = "@a[tag=plm_d_mountain,dx=2,dy=1,dz=2]"
            fresh = zone[:-1] + ",tag=!ds_was_altar]"
            s.tick += [
                prefix + f" run tag {zone} add ds_on_altar",
                prefix
                + f" if score #need ds_seq matches {idx} run particle end_rod ~1.5 ~1.8 ~1.5 0.20 0.8 0.20 0.02 3",
                prefix
                + f" if score #need ds_seq matches {idx} if entity {fresh} run scoreboard players set #stepped ds_count 2",
                prefix
                + f" unless score #need ds_seq matches {idx} if entity {fresh} unless score #stepped ds_count matches 2 run scoreboard players set #stepped ds_count 1",
            ]
            if n == 4:
                s.tick += [
                    f"execute if score #before ds_stage matches 4 if score #need ds_seq matches {idx} unless score #render ds_seq matches {idx} run item replace entity {s.foe} armor.head with minecraft:{head}"
                ]
    s.tick += [
        "scoreboard players operation #render ds_seq = #need ds_seq",
        "tag @a[tag=plm_d_mountain,tag=!ds_on_altar] remove ds_was_altar",
        "tag @a[tag=ds_on_altar,tag=plm_d_mountain] add ds_was_altar",
        "execute if score #stepped ds_count matches 2 unless score #before ds_stage matches 4 run scoreboard players add #mountain ds_count 1",
        "execute if score #before ds_stage matches 4 run function plm:domains/mountain/battle",
    ]
    s.stages[4] += [
        "scoreboard players set #mountain ds_hold 0",
        "scoreboard players set #cycle ds_clock 300",
        "scoreboard players set #render ds_seq -1",
    ]
    s.write(
        "battle",
        [
            "scoreboard players operation #pct ds_hp = #mountain ds_hp",
            "scoreboard players operation #pct ds_hp *= #100 ds_hp",
            "scoreboard players operation #pct ds_hp /= #mountain ds_max",
            "execute if score #pct ds_hp matches ..70 if score #mountain ds_hold matches 0 run scoreboard players set #mountain ds_hold 1",
            "execute if score #pct ds_hp matches ..35 if score #mountain ds_hold matches 1 run function plm:domains/mountain/four",
            "execute if score #mountain ds_hold matches ..1 run scoreboard players remove #cycle ds_clock 1",
            "execute if score #cycle ds_clock matches 20 if score #mountain ds_hold matches 1 positioned ~80 ~1 ~15 run particle flame ~ ~ ~ 2 0.2 2 0 35",
            "execute if score #cycle ds_clock matches 1 if score #mountain ds_hold matches 1 positioned ~80 ~1 ~15 as @a[tag=plm_d_mountain,distance=..4] run damage @s 5",
            "execute if score #cycle ds_clock matches ..0 run function plm:domains/mountain/change",
            "execute if score #stepped ds_count matches 2 if score #mountain ds_hold matches ..1 run scoreboard players set #mountain ds_window 100",
            "execute if score #stepped ds_count matches 2 if score #mountain ds_hold matches 2 run scoreboard players add #mountain ds_count 1",
            "execute if score #mountain ds_count matches 4.. run scoreboard players set #mountain ds_window 100",
            "execute if score #stepped ds_count matches 1 if score #mountain ds_cd matches 0 run function plm:domains/mountain/wrong",
        ],
    )
    s.write(
        "four",
        [
            "scoreboard players set #mountain ds_hold 2",
            "scoreboard players set #mountain ds_window 0",
            "scoreboard players set #mountain ds_count 0",
            'tellraw @a[tag=plm_d_mountain] {"text":"四形合一 · 青龙 → 朱雀 → 白虎 → 玄武"}',
        ],
    )
    s.write(
        "change",
        [
            "scoreboard players add #mountain ds_seq 1",
            "scoreboard players operation #mountain ds_seq %= #four ds_seq",
            "scoreboard players set #cycle ds_clock 300",
            "execute if score #mountain ds_hold matches 1 run scoreboard players set #cycle ds_clock 200",
        ],
    )
    s.write(
        "wrong",
        [
            "scoreboard players set #mountain ds_cd 100",
            "scoreboard players operation #heal ds_hp = #mountain ds_max",
            "scoreboard players operation #heal ds_hp /= #20 ds_hp",
            "scoreboard players operation #mountain ds_hp += #heal ds_hp",
            "scoreboard players operation #mountain ds_hp < #mountain ds_max",
            'tellraw @a[tag=plm_d_mountain] {"text":"踏错祭坛，映主恢复了生命。"}',
        ],
    )
    s.finish()


if __name__ == "__main__":
    mountain()
