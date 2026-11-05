"""泪谷：带围沿的浅池、显影教学、依次灌池以及独立受击盒的抽水轮换。"""

from gen_banquet_tomb import Scene


def valley():
    s = Scene(
        "valley", "prismarine_bricks", "dark_prismarine", "泪神倒影", "turtle_helmet"
    )
    pools = [(12, 12), (46, 12), (67, 4), (79, 4), (84, 20)]
    # 池面与岸同高，池底低一格，八边围住水源。
    for x, z in pools:
        s.setup += [
            f"fill ~{x - 1} ~-1 ~{z - 1} ~{x + 6} ~ ~{z + 6} dark_prismarine",
            f"fill ~{x} ~ ~{z} ~{x + 5} ~ ~{z + 5} air",
        ]
    s.stage(1, "干涸河床 · 右键第一道闸，观察水面。")
    s.prop(
        1,
        "first",
        9,
        13,
        "cut_copper",
        "开第一闸",
        [
            "execute at @e[tag=plm_origin_valley,limit=1] run fill ~12 ~ ~12 ~17 ~ ~17 water",
            "scoreboard players add #valley ds_count 1",
        ],
    )
    s.next(1, 1)
    s.stage(2, "倒置祭坛 · 开闸后击碎水中倒影，显影三次。")
    s.prop(
        2,
        "altar",
        43,
        14,
        "cut_copper",
        "祭坛闸 · 灌水",
        [
            "execute unless entity @e[tag=ds_practice_valley] at @e[tag=plm_origin_valley,limit=1] run function plm:domains/valley/reveal"
        ],
        reusable=True,
    )
    s.write(
        "reveal",
        [
            "fill ~46 ~ ~12 ~51 ~ ~17 water",
            """summon interaction ~48.5 ~1 ~14.5 {Tags:["dm_scene_valley","ds_practice_valley"],width:1.8f,height:2f,CustomNameVisible:1b,CustomName:'{"text":"击碎倒影","color":"aqua"}'}""",
        ],
    )
    s.tick += [
        "execute as @e[tag=ds_practice_valley,limit=1] on attacker if entity @s[tag=plm_d_valley] at @e[tag=plm_origin_valley,limit=1] run function plm:domains/valley/fade"
    ]
    s.write(
        "fade",
        [
            "kill @e[tag=ds_practice_valley]",
            "fill ~46 ~ ~12 ~51 ~ ~17 air",
            "particle splash ~48 ~1 ~14 1 1 1 0 24",
            "scoreboard players add #valley ds_count 1",
        ],
    )
    s.next(2, 3)
    s.stage(3, "泪神池 · 依次开西、北、东三闸；主池将出现倒影。")
    for i, (x, z) in enumerate(pools[2:]):
        s.prop(
            3,
            "pool" + str(i),
            x - 1,
            z + 2,
            "oxidized_copper",
            "西北东"[i] + "闸",
            [
                f"execute unless score #valley ds_count matches {i} run data remove entity @s interaction",
                f"execute unless score #valley ds_count matches {i} run return 0",
                f"execute at @e[tag=plm_origin_valley,limit=1] run fill ~{x} ~ ~{z} ~{x + 5} ~ ~{z + 5} water",
                "scoreboard players add #valley ds_count 1",
            ],
        )
    s.next(3, 3)
    s.stage(4, "攻击池中发光的倒影。池干则跟随水声转移；末段开主闸。")
    s.boss(4, 69, 6)
    s.stages[4] += [
        "scoreboard players set #valley ds_window 36000",
        "scoreboard players set #valley ds_seq 0",
        "scoreboard players set #valley ds_hold 0",
        "setblock ~79 ~1 ~17 dark_prismarine",
        "setblock ~79 ~2 ~17 skeleton_skull",
    ]
    # 抽水时销毁旧 UUID，重召后迟到的箭不能命中已经消失的那次显形。
    spawn = s.stages[4][
        next(i for i, line in enumerate(s.stages[4]) if line.startswith("summon husk"))
    ]
    for i, (x, z) in enumerate(pools[2:]):
        nx, nz = pools[2 + (i + 1) % 3]
        s.write(
            "rotate" + str(i),
            [
                "kill @e[tag=dm_boss_valley]",
                "fill ~%d ~ ~%d ~%d ~ ~%d air" % (x, z, x + 5, z + 5),
                f"fill ~{nx} ~ ~{nz} ~{nx + 5} ~ ~{nz + 5} water",
                spawn.replace("~69.5 ~1 ~6.5", f"~{nx + 2}.5 ~1 ~{nz + 2}.5"),
                f"scoreboard players set #valley ds_seq {(i + 1) % 3}",
                "scoreboard players set #valley ds_cd 300",
            ],
        )
    s.prop(
        4,
        "main",
        80,
        18,
        "waxed_copper_block",
        "主闸 · 全池放水",
        [
            "execute if score #valley ds_hold matches 2 at @e[tag=plm_origin_valley,limit=1] run function plm:domains/valley/flood"
        ],
        reusable=True,
    )
    s.write(
        "flood",
        [f"fill ~{x} ~ ~{z} ~{x + 5} ~ ~{z + 5} water" for x, z in pools[2:]]
        + [
            "tp @e[tag=dm_boss_valley,limit=1] ~81.5 ~1 ~6.5",
            "scoreboard players set #valley ds_window 36000",
            "scoreboard players set #valley ds_hold 3",
        ],
    )
    s.tick += [
        "execute if score #valley ds_stage matches 4 run function plm:domains/valley/boss_tick"
    ]
    s.write(
        "boss_tick",
        [
            "scoreboard players operation #pct ds_hp = #valley ds_hp",
            "scoreboard players operation #pct ds_hp *= #100 ds_hp",
            "scoreboard players operation #pct ds_hp /= #valley ds_max",
            "execute if score #pct ds_hp matches ..70 if score #valley ds_hold matches 0 run scoreboard players set #valley ds_hold 1",
            "execute if score #pct ds_hp matches ..35 if score #valley ds_hold matches 1 run function plm:domains/valley/dry",
            "scoreboard players operation #old ds_seq = #valley ds_seq",
        ]
        + [
            f"execute if score #valley ds_hold matches 1 if score #old ds_seq matches {i} if score #valley ds_cd matches 0 run function plm:domains/valley/rotate{i}"
            for i in range(3)
        ],
    )
    s.write(
        "dry",
        [f"fill ~{x} ~ ~{z} ~{x + 5} ~ ~{z + 5} air" for x, z in pools[2:]]
        + [
            "tp @e[tag=dm_boss_valley,limit=1] ~79.5 ~2 ~17.5",
            "scoreboard players set #valley ds_window 0",
            "scoreboard players set #valley ds_hold 2",
            'tellraw @a[tag=plm_d_valley] {"text":"三池已干，右键中央主闸。"}',
        ],
    )
    s.finish()


if __name__ == "__main__":
    valley()
