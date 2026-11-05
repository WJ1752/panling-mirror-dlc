"""三段镜域施工工具。场景坐标相对域 marker，所有方块只写入该域场地。"""

from gen_domains import DATA, function
import json


def label(message):
    return json.dumps({"text": message, "color": "gold"}, ensure_ascii=False)


class Scene:
    def __init__(self, key, floor, wall, boss, helmet):
        self.key = key
        self.base = "plm:domains/" + key
        self.team = "@a[tag=plm_d_" + key + "]"
        self.owned = "dm_scene_" + key
        self.foe = f"@e[type=husk,tag=dm_boss_{key},limit=1]"
        self.lock = "#" + key
        self.marker = f"@e[tag=plm_origin_{key},type=marker,limit=1]"
        self.boss_name = boss
        self.helmet = helmet
        self.setup = [f"function {self.base}/cleanup"]
        for left in (0, 32, 64):
            self.setup += [
                f"fill ~{left} ~ ~ ~{left + 31} ~23 ~31 air",
                f"fill ~{left} ~ ~ ~{left + 31} ~ ~31 {floor}",
            ]
            for z in (0, 31):
                self.setup += [f"fill ~{left} ~1 ~{z} ~{left + 31} ~6 ~{z} {wall}"]
            for offset in (4, 12, 20, 28):
                for z in (2, 29):
                    self.setup += [
                        f"fill ~{left + offset} ~1 ~{z} ~{left + offset} ~4 ~{z} {wall}",
                        f"setblock ~{left + offset} ~5 ~{z} lantern",
                    ]
        for x in (0, 31, 63, 95):
            self.setup += [f"fill ~{x} ~1 ~1 ~{x} ~6 ~30 {wall}"]
        self.setup += [
            f"scoreboard players set {self.lock} {obj} 0"
            for obj in (
                "ds_stage",
                "ds_count",
                "ds_lamps",
                "ds_hold",
                "ds_cd",
                "ds_window",
                "ds_clock",
                "ds_seq",
            )
        ]
        self.setup += [
            f"scoreboard players operation {self.lock} ds_hp = @s dm_party",
            f"scoreboard players operation {self.lock} ds_hp *= #base ds_hp",
            f"scoreboard players operation {self.lock} ds_hp *= @s dm_depth",
            f"scoreboard players operation {self.lock} ds_max = {self.lock} ds_hp",
        ]
        self.tick = [
            f"scoreboard players add {self.lock} ds_clock 1",
            f"execute if score {self.lock} ds_cd matches 1.. run scoreboard players remove {self.lock} ds_cd 1",
        ]
        self.stages = {}
        self.cycles = []

    def write(self, path, commands):
        function(self.key + "/" + path, "\n".join(commands))

    def stage(self, n, message):
        commands = [
            f"kill @e[tag=ds_prop_{self.key}]",
            f"scoreboard players set {self.lock} ds_stage {n}",
            f"scoreboard players set {self.lock} ds_count 0",
            f"tellraw {self.team} {label(message)}",
        ]
        if n in (2, 3):
            x = 31 if n == 2 else 63
            commands += [f"fill ~{x} ~1 ~12 ~{x} ~5 ~19 air"]
        self.stages[n] = commands
        return commands

    def prop(
        self, n, key, x, z, block, caption, actions, click="interaction", reusable=False
    ):
        tag = f"ds_{self.key}_{key}"
        commands = self.stages[n]
        pos = f"~{x}.5 ~2 ~{z}.5"
        commands += [
            f"setblock ~{x} ~1 ~{z} {block}",
            f"""summon interaction {pos} {{Tags:["{self.owned}","ds_prop_{self.key}","{tag}"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{label(caption)}'}}""",
        ]
        rel = "target" if click == "interaction" else "attacker"
        sel = f"@e[type=interaction,tag={tag},limit=1]"
        self.tick += [
            f"execute if score {self.lock} ds_stage matches {n} as {sel} at @s if data entity @s {click} run function {self.base}/prop/{key}"
        ]
        commands = [
            "scoreboard players set #valid ds_count 0",
            f"execute on {rel} if entity @s[tag=plm_d_{self.key}] run scoreboard players set #valid ds_count 1",
            f"execute unless score #valid ds_count matches 1 run data remove entity @s {click}",
            "execute unless score #valid ds_count matches 1 run return 0",
        ] + actions
        commands += [f"data remove entity @s {click}"] if reusable else ["kill @s"]
        self.write("prop/" + key, commands)

    def next(self, stage, count):
        self.tick += [
            f"execute if score {self.lock} ds_stage matches {stage} if score {self.lock} ds_count matches {count}.. run function {self.base}/stage/{stage + 1}"
        ]

    def boss(self, stage, x=82, z=15, y=1):
        self.stages[stage] += [
            f"""summon husk ~{x}.5 ~{y} ~{z}.5 {{Tags:["{self.owned}","dm_boss_{self.key}","dm_boss","monster"],Health:1024f,Attributes:[{{Name:"generic.max_health",Base:1024d}},{{Name:"generic.knockback_resistance",Base:1d}}],DeathLootTable:"minecraft:empty",ArmorDropChances:[0f,0f,0f,0f],NoAI:1b,Silent:1b,PersistenceRequired:1b,Invulnerable:1b,AbsorptionAmount:2048f,CustomNameVisible:1b,CustomName:'{label(self.boss_name)}',ArmorItems:[{{}},{{}},{{}},{{id:"minecraft:{self.helmet}",Count:1b}}]}}"""
        ]
        self.tick += [
            f"execute if score {self.lock} ds_stage matches {stage}.. unless entity {self.foe} run function {self.base}/abort",
            f"execute unless score {self.lock} dm_state matches 2 run return 0",
        ]
        # 真实武器产生的原版吸收伤害，只有队员命中的进度事件能扣局内血量。
        path = DATA / f"advancements/domains/hit_{self.key}.json"
        hit = {
            "trigger": "minecraft:player_hurt_entity",
            "conditions": {"entity": {"nbt": '{Tags:["dm_boss_' + self.key + '"]}'}},
        }
        path.write_text(
            json.dumps(
                {"criteria": {"hit": hit}, "rewards": {"function": self.base + "/hit"}},
                indent=2,
            )
            + "\n"
        )
        self.write(
            "hit",
            [
                f"advancement revoke @s only plm:domains/hit_{self.key}",
                f"scoreboard players set #hit ds_hp 2048",
                f"execute store result score #left ds_hp run data get entity {self.foe} AbsorptionAmount 1",
                "scoreboard players operation #hit ds_hp -= #left ds_hp",
                f"data modify entity {self.foe} AbsorptionAmount set value 2048f",
                f"execute unless entity @s[tag=plm_d_{self.key}] run return 0",
                f"execute unless score {self.lock} ds_window matches 1.. run return 0",
                # 盘灵将原版攻击力缩至万分之一。真实命中事件保留，实际强度来自本体武器计分。
                "execute if score #hit ds_hp matches ..0 run function plm:domains/weapon_hit",
                # 盘灵武器伤害单位转换；用局内上限截断单击。
                "scoreboard players operation #hit ds_hp *= #scale ds_hp",
                "execute if score #hit ds_hp matches 401.. run scoreboard players set #hit ds_hp 400",
                f"scoreboard players operation {self.lock} ds_hp -= #hit ds_hp",
            ],
        )
        self.cycles += [
            f"execute if score {self.lock} ds_stage matches {stage}.. if score {self.lock} ds_hp matches ..0 run function {self.base}/win",
            f"execute unless score {self.lock} dm_state matches 2 run return 0",
            f"execute if score {self.lock} ds_stage matches {stage}.. as {self.foe} run function {self.base}/shield",
        ]
        self.write(
            "shield",
            [
                f"execute if score {self.lock} ds_window matches 1.. if data entity @s {{Invulnerable:1b}} run data merge entity @s {{Invulnerable:0b,Glowing:1b}}",
                f"execute unless score {self.lock} ds_window matches 1.. unless data entity @s {{Invulnerable:1b}} run data merge entity @s {{Invulnerable:1b,Glowing:0b}}",
            ],
        )
        self.cycles += [
            f"execute if score {self.lock} ds_window matches 1.. run scoreboard players remove {self.lock} ds_window 1",
            f'execute if score {self.lock} ds_stage matches {stage}.. if score {self.lock} ds_clock matches 40.. run title {self.team} actionbar [{{"text":"{self.boss_name}　"}},{{"score":{{"name":"{self.lock}","objective":"ds_hp"}}}}]',
            f"execute if score {self.lock} ds_clock matches 40.. run scoreboard players set {self.lock} ds_clock 0",
        ]

    def finish(self):
        self.write("setup", self.setup + [f"function {self.base}/stage/1"])
        for n, body in self.stages.items():
            self.write("stage/" + str(n), body)
        self.write("tick", self.tick + self.cycles)
        self.write("cleanup", [f"kill @e[tag={self.owned}]"])
        self.write(
            "checkpoint",
            [
                f"execute if score {self.lock} ds_stage matches {s} run tp @a[tag=plm_d_{self.key},tag=plm_rescue] ~{x}.5 ~1 ~15.5 -90 0"
                for s, x in [("1", 3), ("2", 34), ("3..", 66)]
            ],
        )


def banquet():
    s = Scene(
        "fire",
        "polished_blackstone_bricks",
        "red_nether_bricks",
        "双心炎魔",
        "golden_helmet",
    )
    s.setup += [
        "fill ~7 ~1 ~12 ~27 ~1 ~13 dark_oak_planks",
        "fill ~7 ~1 ~18 ~27 ~1 ~19 dark_oak_planks",
        "fill ~87 ~1 ~12 ~92 ~2 ~18 polished_basalt",
    ]
    for n, name, points in [
        (1, "宴厅 · 击碎桌旁三件摆设", [(9, 15), (18, 10), (25, 21)]),
        (
            2,
            "酒窖 · 击碎五坛后绕柱避开火环",
            [(36, 8), (40, 22), (46, 8), (51, 22), (57, 8)],
        ),
        (3, "王座 · 击碎冠、杯、旗", [(72, 11), (78, 21), (85, 11)]),
    ]:
        s.stage(n, name)
        for i, (x, z) in enumerate(points):
            kinds = (
                ["gilded_blackstone", "flower_pot", "red_banner"]
                if n == 3
                else ["decorated_pot"] * 5
            )
            actions = [
                "setblock ~ ~-1 ~ air",
                "particle flame ~ ~ ~ 1.4 0.2 1.4 0.04 32",
                f"scoreboard players add #fire ds_count 1",
            ]
            if n == 2 or (n == 1 and i):
                actions += [
                    'summon marker ~ ~ ~ {Tags:["dm_scene_fire","ds_fire_ember"]}'
                ]
            s.prop(
                n,
                f"jar{n}_{i}",
                x,
                z,
                kinds[i],
                ["冠", "杯", "旗"][i] if n == 3 else "击碎 · 酒坛",
                actions,
                "attack",
            )
        s.next(n, len(points))
    s.stage(4, "双心炎魔 · 击碎供品后追击发光的双心。")
    s.boss(4)
    # 重摆永远保留一个可砸的供品，末段按冠、杯、旗顺序激活。
    s.stages[4] += [
        "scoreboard players set #fire ds_phase 1",
        "scoreboard players set #fire ds_seq 0",
        "function plm:domains/fire/offer0",
    ]
    for i, (x, z, block, title) in enumerate(
        [
            (77, 12, "gilded_blackstone", "王冠"),
            (80, 20, "decorated_pot", "金杯"),
            (86, 14, "red_banner", "战旗"),
        ]
    ):
        start = len(s.stages[4])
        actions = [
            "setblock ~ ~-1 ~ air",
            "particle soul_fire_flame ~ ~ ~ 1 1 1 0.04 35",
            "scoreboard players set #fire ds_window 100",
            "scoreboard players set #fire ds_hold 120",
            "execute if score #fire ds_phase matches 3 unless score #fire ds_seq matches 2 run scoreboard players set #fire ds_window 0",
            "execute if score #fire ds_phase matches 3 unless score #fire ds_seq matches 2 run scoreboard players set #fire ds_hold 20",
            "scoreboard players operation #ratio ds_hp = #fire ds_hp",
            "scoreboard players operation #ratio ds_hp *= #100 ds_hp",
            "scoreboard players operation #ratio ds_hp /= #fire ds_max",
            "execute if score #ratio ds_hp matches 36..70 run scoreboard players set #fire ds_hold 400",
            'summon marker ~ ~ ~ {Tags:["dm_scene_fire","ds_fire_ember"]}',
            f"scoreboard players set #fire ds_seq {(i + 1) % 3}",
            "execute as @e[tag=dm_boss_fire,limit=1] at @s facing entity @p[tag=plm_d_fire] eyes run tp @s ~ ~ ~ ~ ~",
            'execute if score #fire ds_window matches 1.. run tellraw @a[tag=plm_d_fire] {"text":"双心暴露！五秒内攻击炎魔。","color":"red"}',
        ]
        s.prop(4, "offer_" + str(i), x, z, block, "击碎 · " + title, actions, "attack")
        s.write("offer" + str(i), s.stages[4][start:])
        del s.stages[4][start:]
    s.tick += [
        "execute if score #fire ds_hold matches 1.. run scoreboard players remove #fire ds_hold 1",
        "execute if score #fire ds_stage matches 4 if score #fire ds_hold matches 0 unless entity @e[tag=ds_prop_fire] run function plm:domains/fire/reset_offer",
        "execute as @e[tag=ds_fire_ember] at @s run function plm:domains/fire/ember",
        'execute if score #fire ds_stage matches 4 if score #fire ds_clock matches 40 if score #fire ds_window matches 0 at @p[tag=plm_d_fire] run summon marker ~ ~ ~ {Tags:["dm_scene_fire","ds_fire_ember"]}',
    ]
    s.tick += [
        "execute if score #fire ds_stage matches 4 run function plm:domains/fire/phase_check"
    ]
    s.write(
        "phase_check",
        [
            "scoreboard players operation #ratio ds_hp = #fire ds_hp",
            "scoreboard players operation #ratio ds_hp *= #100 ds_hp",
            "scoreboard players operation #ratio ds_hp /= #fire ds_max",
            'execute if score #ratio ds_hp matches ..70 if score #fire ds_phase matches 1 run tellraw @a[tag=plm_d_fire] {"text":"炎魔开始重摆宴席。打断供品，再追双心。"}',
            "execute if score #ratio ds_hp matches ..70 if score #fire ds_phase matches 1 run scoreboard players set #fire ds_phase 2",
            "execute if score #ratio ds_hp matches ..35 if score #fire ds_phase matches 2 run function plm:domains/fire/last",
        ],
    )
    s.write(
        "last",
        [
            "scoreboard players set #fire ds_phase 3",
            "scoreboard players set #fire ds_seq 0",
            "scoreboard players set #fire ds_window 0",
            "scoreboard players set #fire ds_hold 1",
            "kill @e[tag=ds_prop_fire]",
            'tellraw @a[tag=plm_d_fire] {"text":"最后的供品：依次砸冠、杯、旗，双心才会同时显形。"}',
        ],
    )
    s.write(
        "reset_offer",
        [
            f"execute if score #fire ds_seq matches {i} run function plm:domains/fire/offer{i}"
            for i in range(3)
        ],
    )
    s.write(
        "ember",
        [
            "scoreboard players add @s ds_clock 1",
            "particle flame ~ ~ ~ 1.2 0.1 1.2 0 8",
            "execute if score @s ds_clock matches 20 as @a[tag=plm_d_fire,distance=..3] run damage @s 4 minecraft:on_fire",
            "execute if score @s ds_clock matches 20.. run kill @s",
        ],
    )
    s.finish()


def mausoleum():
    s = Scene(
        "tomb",
        "deepslate_tiles",
        "chiseled_stone_bricks",
        "无面守陵人",
        "carved_pumpkin",
    )
    s.setup += ["fill ~76 ~1 ~13 ~83 ~2 ~17 polished_basalt"]
    for n, points in [
        (1, [(10, 9), (18, 20), (25, 10)]),
        (2, [(38, 8), (46, 20), (55, 9)]),
        (3, [(73, 10), (85, 10), (85, 21), (73, 21)]),
    ]:
        s.stage(
            n,
            [
                "",
                "长明灯室 · 在烛匣取烛，再右键点亮三台。",
                "石像长廊 · 点亮有脸石像，避开无面守卫。",
                "空棺 · 点亮棺角四灯。",
            ][n],
        )
        s.prop(
            n,
            "box" + str(n),
            32 * (n - 1) + 5,
            10,
            "chiseled_bookshelf",
            "烛匣 · 补充长明烛",
            [
                "execute on target run scoreboard players set @s ds_wick 4",
                'execute on target run tellraw @s {"text":"已取四支长明烛。"}',
            ],
            reusable=True,
        )
        for i, (x, z) in enumerate(points):
            if n == 2:
                s.setup += [f"setblock ~{x + 1} ~1 ~{z} carved_pumpkin"]
            s.prop(
                n,
                f"lamp{n}_{i}",
                x,
                z,
                "candle",
                "点灯",
                [
                    "scoreboard players set #wick ds_count 0",
                    "execute on target if score @s ds_wick matches 1.. run scoreboard players set #wick ds_count 1",
                    'execute unless score #wick ds_count matches 1 on target run tellraw @s {"text":"先从烛匣取烛。"}',
                    "execute unless score #wick ds_count matches 1 run data remove entity @s interaction",
                    "execute unless score #wick ds_count matches 1 run return 0",
                    "execute on target run scoreboard players remove @s ds_wick 1",
                    "setblock ~ ~-1 ~ lantern",
                    "particle soul ~ ~ ~ 0.4 0.4 0.4 0.02 10",
                    "scoreboard players add #tomb ds_count 1",
                ],
            )
        if n == 2:
            s.prop(
                n,
                "false_face",
                48,
                8,
                "polished_basalt",
                "无面石像",
                ['summon husk ~ ~ ~ {Tags:["dm_scene_tomb","monster"],DeathLootTable:"minecraft:empty",PersistenceRequired:1b}'],
            )
        s.next(n, len(points))
    s.stage(4, "守陵人 · 领它走入灯圈。守卫会吹灯，右键补灯；残血须守四灯十秒。")
    s.boss(4, 80, 10)
    for i, (x, z) in enumerate([(73, 10), (85, 10), (85, 21), (73, 21)]):
        tag = f"ds_tomb_flame{i}"
        s.prop(
            4,
            f"flame{i}",
            x,
            z,
            "lantern",
            "棺角灯 · 右键重燃",
            ["setblock ~ ~-1 ~ lantern", "particle flame ~ ~ ~ 0.3 0.3 0.3 0 8"],
            reusable=True,
        )
        s.tick += [
            f"execute if score #tomb ds_stage matches 4 positioned ~{x} ~1 ~{z} if block ~ ~ ~ lantern run scoreboard players add #tomb ds_lamps 1",
            f"execute if score #tomb ds_stage matches 4 if score #tomb ds_seq matches 0..1 positioned ~{x} ~1 ~{z} if block ~ ~ ~ lantern if entity @e[tag=dm_boss_tomb,distance=..8] run scoreboard players set #tomb ds_window 3",
        ]
    s.tick.insert(0, "scoreboard players set #tomb ds_lamps 0")
    s.stages[4] += [
        "scoreboard players set #tomb ds_seq 0",
        "scoreboard players set #tomb ds_hold 0",
    ]
    s.tick += [
        "execute if score #tomb ds_stage matches 4 run function plm:domains/tomb/watch"
    ]
    s.write(
        "watch",
        [
            "scoreboard players operation #pct ds_hp = #tomb ds_hp",
            "scoreboard players operation #pct ds_hp *= #100 ds_hp",
            "scoreboard players operation #pct ds_hp /= #tomb ds_max",
            "execute if score #pct ds_hp matches ..70 if score #tomb ds_seq matches 0 run scoreboard players set #tomb ds_seq 1",
            "execute if score #pct ds_hp matches ..35 if score #tomb ds_seq matches 1 run function plm:domains/tomb/last",
            "execute if score #tomb ds_clock matches 40 as @e[tag=dm_boss_tomb,limit=1] at @s facing entity @p[tag=plm_d_tomb,distance=..25] feet positioned ^ ^ ^0.8 if block ~ ~ ~ air run tp @s ~ ~ ~",
            "execute if score #tomb ds_seq matches 1 if score #tomb ds_cd matches 0 run function plm:domains/tomb/blow",
            "execute if score #tomb ds_seq matches 1 if score #tomb ds_lamps matches 0 if score #tomb ds_clock matches 40 run scoreboard players add #tomb ds_hp 12",
            "execute if score #tomb ds_seq matches 2 unless score #tomb ds_lamps matches 4 run scoreboard players set #tomb ds_hold 0",
            "execute if score #tomb ds_seq matches 2 if score #tomb ds_lamps matches 4 run scoreboard players add #tomb ds_hold 1",
            "execute if score #tomb ds_hold matches 200.. run scoreboard players set #tomb ds_window 20",
        ],
    )
    s.write(
        "last",
        [
            "scoreboard players set #tomb ds_seq 2",
            "scoreboard players set #tomb ds_window 0",
            "scoreboard players set #tomb ds_hold 0",
            "execute at @e[tag=ds_prop_tomb,limit=1] run setblock ~ ~-1 ~ soul_sand",
            'tellraw @a[tag=plm_d_tomb] {"text":"空棺闭合。四角同亮并守住十秒。"}',
        ],
    )
    s.write(
        "blow",
        [
            'execute at @e[tag=ds_prop_tomb,sort=random,limit=2] run summon husk ~ ~ ~ {Tags:["dm_scene_tomb","ds_wind_tomb","monster"],NoGravity:1b,DeathLootTable:"minecraft:empty",Silent:1b,NoAI:1b,Health:6f,PersistenceRequired:1b,CustomNameVisible:1b,CustomName:\'{"text":"吹灯影 · 击退"}\'}',
            "scoreboard players set #tomb ds_cd 120",
        ],
    )
    s.tick += [
        "execute as @e[tag=ds_wind_tomb] at @s run function plm:domains/tomb/wind"
    ]
    s.write(
        "wind",
        [
            "scoreboard players add @s ds_clock 1",
            "particle ash ~ ~1 ~ 0.3 0.4 0.3 0 3",
            "execute if score @s ds_clock matches 45.. unless data entity @s {Health:0.0f} run setblock ~ ~-1 ~ soul_sand",
            "execute if score @s ds_clock matches 45.. run kill @s",
        ],
    )
    s.finish()


if __name__ == "__main__":
    banquet()
    mausoleum()
