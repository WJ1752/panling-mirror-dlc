"""生成五域的公共入口、报名、生命周期与结算。域内场景由各域目录维护。"""

import json
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "datapack/data/plm"
ROOT = DATA / "functions/domains"
# 原版入口坐标取自生产本体世界；x 为独立维度活动区原点。
DOMAINS = [
    ("fire", "炎巢", "fire", 256, (-309, 11, 801)),
    ("tomb", "皇陵", "metal", 512, (606, 10, -130)),
    ("tower", "妖塔", "wood", 768, (-195, 65, -180)),
    ("valley", "泪谷", "water", 1024, (-690, 108, -637)),
    ("mountain", "圣山", "earth", 1280, (-177, 99, -831)),
]


def function(name, commands):
    path = ROOT / (name + ".mcfunction")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(commands.strip() + "\n", encoding="utf-8")


def control(key, caption, pos, action):
    """逐次 advancement 消费交互，以实际右键玩家身份调用；同 tick 的两人独立。"""
    tag = "plm_gate_" + key
    path = DATA / "advancements/domains" / (key + ".json")
    path.parent.mkdir(parents=True, exist_ok=True)
    criterion = {
        "trigger": "minecraft:player_interacted_with_entity",
        "conditions": {"entity": {"nbt": '{Tags:["' + tag + '"]}'}},
    }
    path.write_text(
        json.dumps(
            {
                "criteria": {"use": criterion},
                "rewards": {"function": "plm:domains/use/" + key},
            },
            indent=2,
        )
        + "\n",
        encoding="utf-8",
    )
    function("use/" + key, f"advancement revoke @s only plm:domains/{key}\n" + action)
    label = json.dumps({"text": caption, "color": "aqua"}, ensure_ascii=False)
    return (
        f"""summon interaction {pos} {{Tags:["{tag}"],width:1.6f,height:2.2f,response:1b,"""
        f"""Passengers:[{{id:"minecraft:text_display",billboard:"center",alignment:"center",transformation:{{translation:[0f,0.5f,0f],scale:[1f,1f,1f],left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f]}},text:'{label}'}}]}}"""
    )


def material(item, count):
    # 复用发料函数中的正式物品 NBT（与商人、磨镜台堆叠一致）。
    for line in (
        (DATA / "functions/dev/give_mats.mcfunction")
        .read_text(encoding="utf-8")
        .splitlines()
    ):
        if f'id:"panling:mirror_{item}"' in line and line.startswith("give @s "):
            base, tag = line.split()[2].split("{", 1)
            return f'{{id:"{base}",Count:{count}b,tag:{{{tag}}}'
    raise ValueError(item)


def generate():
    function(
        "weapon_hit",
        """
scoreboard players set #hit ds_hp 1
execute if score @s attack_damage1 matches 10.. run scoreboard players operation #hit ds_hp = @s attack_damage1
execute if score @s attack_damage1 matches 10.. run scoreboard players operation #hit ds_hp /= 10 int
""",
    )
    function(
        "skill_armor",
        """
function pld:pre/damage/operation/armor
function pld:pre/damage/operation/enchant
function plm:domains/skill_apply
""",
    )
    function(
        "skill_true",
        """
scoreboard players operation @s entity_hurt_temp = #temp entity_hurt_temp
function plm:domains/skill_apply
""",
    )
    skill = [
        "function pld:pre/damage/operation/effect/check",
        "scoreboard players operation #skill ds_hp = @s entity_hurt_temp",
        "scoreboard players operation #skill ds_hp /= #unit ds_hp",
        "scoreboard players operation #skill ds_hp *= #scale ds_hp",
        "execute if score #skill ds_hp matches 401.. run scoreboard players set #skill ds_hp 400",
        "execute unless score #skill ds_hp matches 1.. run return 0",
    ]
    for d, *_ in DOMAINS:
        skill += [
            f"execute if entity @s[tag=dm_boss_{d}] if score #{d} ds_window matches 1.. as @a[tag=mirror_arena_damage_owner,tag=plm_d_{d},limit=1] if score @s dm_run = #{d} dm_run run scoreboard players operation #{d} ds_hp -= #skill ds_hp"
        ]
    function("skill_apply", "\n".join(skill))
    objectives = "dm_run dm_state dm_time dm_depth dm_party dm_age dm_paid dm_back dm_score dm_deaths dm_dead dm_leave dm_home".split()
    load = [f"scoreboard objectives add {obj} dummy" for obj in objectives]
    load += [
        "scoreboard objectives add dm_died deathCount",
        "execute in plm:domains run forceload add 0 0 31 31",
    ]
    load += [
        "scoreboard objectives add " + obj + " dummy"
        for obj in "ds_stage ds_count ds_lamps ds_hold ds_cd ds_window ds_clock ds_seq ds_hp ds_max ds_wick ds_phase".split()
    ]
    load += [
        "scoreboard players set #base ds_hp 4200",
        "scoreboard players set #unit ds_hp 10000",
        "scoreboard players set #scale ds_hp 12",
        "scoreboard players set #100 ds_hp 100",
        "scoreboard players set #20 ds_hp 20",
        "scoreboard players set #four ds_seq 4",
    ]
    load += [
        f"scoreboard players set #{key} dm_score {n}"
        for key, n in [("five", 5), ("ten", 10), ("600", 600)]
    ]
    tick = [
        "execute in plm:domains if loaded 31 64 31 unless entity @e[tag=plm_hub] run function plm:domains/hub"
    ]
    hub = [
        "fill 0 63 0 31 63 31 polished_deepslate",
        "fill 0 64 0 31 64 0 polished_blackstone_bricks",
        "fill 0 64 31 31 64 31 polished_blackstone_bricks",
        "fill 0 64 1 0 64 30 polished_blackstone_bricks",
        "fill 31 64 1 31 64 30 polished_blackstone_bricks",
        "setblock 21 64 6 ender_chest",
        "fill 2 63 14 29 63 16 sea_lantern",
        "setblock 14 64 6 dropper[facing=up]",
        "execute positioned 18 64 6 run function plm:mirror/hub/merchant",
        "data merge entity @e[type=villager,tag=plm_merchant,x=18,y=64,z=6,distance=..2,limit=1] {NoAI:1b,Invulnerable:1b,PersistenceRequired:1b}",
        control(
            "work",
            "磨镜台 · 放料后右键",
            "15.5 64 6.5",
            "execute positioned 14 64 6 run function plm:mirror/table/main",
        ),
        control(
            "exit",
            "返回来时的入口",
            "16.5 64 25.5",
            'execute unless entity @s[tag=plm_enrolled] run function plm:domains/return_home\ntellraw @s[tag=plm_enrolled] {"text":"已报名，请等候开门。"}',
        ),
        control(
            "depth",
            "切换镜深 Ⅰ–Ⅴ",
            "10.5 64 8.5",
            """
scoreboard players add @s dm_depth 1
execute if score @s dm_depth matches 6.. run scoreboard players set @s dm_depth 1
tellraw @s [{"text":"所选镜深 "},{"score":{"name":"@s","objective":"dm_depth"}}]
""",
        ),
    ]
    tick += [
        "execute as @a[tag=plm_hub_respawn,nbt=!{Health:0.0f}] in plm:domains run tp @s 16.5 64 16.5",
        "tag @a[tag=plm_hub_respawn,nbt=!{Health:0.0f}] remove plm_hub_respawn",
    ]
    returns = []
    for number, (domain, name, element, x, portal) in enumerate(DOMAINS, 1):
        domain_functions(
            number, domain, name, element, x, portal, load, tick, hub, returns
        )
    hub += ['summon marker 16 64 16 {Tags:["plm_hub"]}']
    function("load", "\n".join(load))
    function("tick", "\n".join(tick))
    function("hub", "\n".join(hub))
    function("return_home", "\n".join(returns))


def domain_functions(i, d, name, element, x, portal, load, tick, hub, returns):
    base = "plm:domains/" + d
    member = "plm_d_" + d
    lock = "#" + d
    players = f"@a[tag={member}]"
    marker = f"@e[type=marker,tag=plm_origin_{d},limit=1]"
    origin = f"{x}.0 64 0.0"
    pos = " ".join(map(str, portal))
    area = f"{x} 0 {x + 95} 31"
    gate_x = i * 5
    depth = f"dm_max_{d}"
    load += [
        f"scoreboard objectives add {depth} dummy",
        f"scoreboard players add {lock} dm_state 0",
    ]
    # 原版区只生成悬浮门牌，不覆盖方块或强加载本体。
    function(
        d + "/place_gate",
        control(
            "map_" + d,
            f"重华台 · {name}镜门",
            "~ ~ ~",
            f"""
tag @s add plm_seen_{d}
scoreboard players set @s dm_home {i}
scoreboard players set @s dm_depth 1
execute in plm:domains run tp @s {gate_x}.5 64 13.5 180 0
tellraw @s {{"text":"右键前方域门报名。五秒内可加入同域队伍。南侧门返回原地图。"}}
""",
        ),
    )
    tick += [
        f"execute in minecraft:overworld positioned {pos} if entity @a[distance=..24] unless entity @e[type=interaction,tag=plm_gate_map_{d},distance=..1] run function {base}/place_gate"
    ]
    returns += [
        f"execute if score @s dm_home matches {i} in minecraft:overworld run tp @s {pos}"
    ]
    hub += [
        f"setblock {gate_x} 63 10 amethyst_block",
        control(
            "join_" + d,
            f"{name} · 报名",
            f"{gate_x}.5 64 10.5",
            f"function {base}/join",
        ),
    ]
    function(
        d + "/join",
        f"""
execute unless entity @s[tag=plm_seen_{d}] run tellraw @s {{"text":"请先在对应的原版入口发现此域镜门。"}}
execute unless entity @s[tag=plm_seen_{d}] run return 0
execute if entity @s[gamemode=spectator] run return 0
execute if entity @s[tag=plm_enrolled] run return 0
execute unless score @s {depth} matches 1.. run scoreboard players set @s {depth} 1
execute if score @s dm_depth > @s {depth} run tellraw @s {{"text":"请先通关前一镜深。"}}
execute if score @s dm_depth > @s {depth} run return 0
execute if score {lock} dm_state matches 2.. run tellraw @s {{"text":"此域已有队伍挑战。"}}
execute if score {lock} dm_state matches 2.. run return 0
execute if score {lock} dm_state matches 0 if score #slots dm_party matches 2.. run tellraw @s {{"text":"两座镜域均已占用，请稍后再试。"}}
execute if score {lock} dm_state matches 0 if score #slots dm_party matches 2.. run return 0
execute if score {lock} dm_state matches 0 run function {base}/reserve
execute unless score @s dm_depth = {lock} dm_depth run tellraw @s {{"text":"本队镜深不同，请切换后报名。"}}
execute unless score @s dm_depth = {lock} dm_depth run return 0
execute if score {lock} dm_party matches 4.. run tellraw @s {{"text":"本队已满四人。"}}
execute if score {lock} dm_party matches 4.. run return 0
tag @s add {member}
tag @s add plm_enrolled
scoreboard players operation @s dm_run = {lock} dm_run
scoreboard players set @s dm_dead 0
scoreboard players set @s dm_leave 0
scoreboard players add {lock} dm_party 1
tellraw @s {{"text":"已报名{name}。请在重华台等候开门。"}}
""",
    )
    function(
        d + "/reserve",
        f"""
scoreboard players add #slots dm_party 1
scoreboard players add #next dm_run 1
scoreboard players operation {lock} dm_run = #next dm_run
scoreboard players operation {lock} dm_depth = @s dm_depth
scoreboard players set {lock} dm_party 0
scoreboard players set {lock} dm_state 1
scoreboard players set {lock} dm_time 100
execute in plm:domains run forceload add {area}
""",
    )
    tick += [
        f"execute as {players} unless score @s dm_run = {lock} dm_run run function {base}/recover",
        f"execute if score {lock} dm_state matches 1 run scoreboard players remove {lock} dm_time 1",
        f"execute if score {lock} dm_state matches 1 if score {lock} dm_time matches ..0 in plm:domains if loaded {x} 64 0 if loaded {x + 95} 64 31 positioned {origin} run function {base}/start",
        f"execute if score {lock} dm_state matches 2 in plm:domains positioned {origin} if loaded ~ ~ ~ unless entity {marker} run function {base}/abort",
        f"execute if score {lock} dm_state matches 2 in plm:domains as {marker} at @s run function {base}/step",
    ]
    retreat = control(
        "retreat_" + d,
        "返回重华台 · 放弃本局",
        "~3.5 ~1 ~11.5",
        f"""
execute unless entity @s[tag={member}] run return 0
scoreboard players remove {lock} dm_party 1
function {base}/leave
""",
    )
    function(
        d + "/retreat_gate",
        retreat.replace('Tags:["plm_gate_', f'Tags:["dm_scene_{d}","plm_gate_').replace(
            'id:"minecraft:text_display",',
            f'id:"minecraft:text_display",Tags:["dm_scene_{d}"],',
        ),
    )
    function(
        d + "/start",
        f"""
summon marker ~ ~ ~ {{Tags:["plm_origin_{d}"]}}
execute as {marker} run function {base}/begin
""",
    )
    function(
        d + "/begin",
        f"""
scoreboard players operation @s dm_run = {lock} dm_run
scoreboard players operation @s dm_depth = {lock} dm_depth
execute store result score @s dm_party if entity {players}
scoreboard players set {lock} dm_state 2
execute unless entity {players} run function {base}/abort
execute unless score {lock} dm_state matches 2 run return 0
execute as @a[tag={member},gamemode=survival] run tag @s add plm_was_survival
gamemode adventure @a[tag={member},gamemode=survival]
scoreboard players set {players} dm_died 0
scoreboard players set {players} dm_dead 0
scoreboard players set @s dm_age 0
scoreboard players set {lock} dm_deaths 0
scoreboard players set {players} dm_leave 0
execute as {players} run scoreboard players operation @s dm_leave = @s mirror_leave
function {base}/setup
function {base}/retreat_gate
tp {players} ~3.5 ~1 ~15.5 -90 0
""",
    )
    function(
        d + "/step",
        f"""
scoreboard players add @s dm_age 1
execute if score @s dm_age matches 36000.. run function {base}/abort
execute unless score {lock} dm_state matches 2 run return 0
execute as @a[tag={member},scores={{dm_died=1..}}] run scoreboard players add {lock} dm_deaths 1
execute as @a[tag={member},scores={{dm_died=1..}}] run scoreboard players set @s dm_dead 1
scoreboard players set {players} dm_died 0
execute unless entity @a[tag={member},scores={{dm_dead=0}}] run function {base}/abort
execute unless score {lock} dm_state matches 2 run return 0
execute as {players} if score @s mirror_leave > @s dm_leave run tag @s add plm_rescue
execute as {players} run scoreboard players operation @s dm_leave = @s mirror_leave
execute as {players} at @s unless dimension plm:domains run tag @s add plm_rescue
execute as {players} unless entity @s[tag=plm_rescue] unless entity @s[x={x},y=58,z=-2,dx=96,dy=34,dz=35] unless data entity @s {{Health:0.0f}} run damage @s 2 minecraft:fall
execute as {players} unless entity @s[x={x},y=58,z=-2,dx=96,dy=34,dz=35] run tag @s add plm_rescue
tag @a[tag={member},scores={{dm_dead=1}},nbt=!{{Health:0.0f}}] add plm_rescue
tag @a[tag={member},nbt={{Health:0.0f}}] remove plm_rescue
execute if entity @a[tag={member},tag=plm_rescue] run function {base}/checkpoint
scoreboard players set @a[tag={member},tag=plm_rescue] dm_dead 0
tag @a[tag={member}] remove plm_rescue
function {base}/tick
""",
    )
    function(
        d + "/win",
        f"""
execute unless score {lock} dm_state matches 2 run return 0
scoreboard players set {lock} dm_state 3
scoreboard players operation #settle dm_age = @s dm_age
scoreboard players operation #settle dm_depth = @s dm_depth
scoreboard players operation #settle dm_deaths = {lock} dm_deaths
execute store result score #online dm_party if entity {players}
execute if score #online dm_party < {lock} dm_party run function {base}/save_receipt
execute as {players} unless score @s dm_paid = @s dm_run run function {base}/reward
function {base}/release
""",
    )
    function(
        d + "/save_receipt",
        f"""
data modify storage plm:domains receipt set value {{}}
scoreboard players operation #pending dm_party = {lock} dm_party
scoreboard players operation #pending dm_party -= #online dm_party
execute store result storage plm:domains receipt.pending int 1 run scoreboard players get #pending dm_party
execute store result storage plm:domains receipt.run int 1 run scoreboard players get @s dm_run
execute store result storage plm:domains receipt.depth int 1 run scoreboard players get @s dm_depth
execute store result storage plm:domains receipt.age int 1 run scoreboard players get @s dm_age
execute store result storage plm:domains receipt.deaths int 1 run scoreboard players get {lock} dm_deaths
data modify storage plm:domains {d}_wins append from storage plm:domains receipt
""",
    )
    attachments = ",".join(
        material(item, count)
        for item, count in [
            ("shard_" + element, 10),
            ("dust", 48),
            ("core", 2),
            ("sand", 2),
        ]
    )
    function(
        d + "/reward",
        f"""
scoreboard players operation @s dm_paid = @s dm_run
scoreboard players set @s dm_score 100
scoreboard players operation #penalty dm_score = #settle dm_deaths
scoreboard players operation #penalty dm_score *= #ten dm_score
scoreboard players operation @s dm_score -= #penalty dm_score
scoreboard players operation #late dm_score = #settle dm_age
scoreboard players remove #late dm_score 18000
scoreboard players operation #late dm_score /= #600 dm_score
scoreboard players operation #late dm_score *= #five dm_score
execute if score #late dm_score matches 1.. run scoreboard players operation @s dm_score -= #late dm_score
data modify storage pld:system Temp_player_new_mails set value [{{sent:"重华台",is_taked:0b,title:'{{"text":"{name} · 通关材料"}}',content:['{{"text":"镜片与影尘可在重华台影商兑换。"}}'],attached_items:[{attachments}]}}]
execute if score @s dm_score matches 90.. run data modify storage pld:system Temp_player_new_mails[0].attached_items[0].Count set value 13b
execute if score @s dm_score matches 90.. run data modify storage pld:system Temp_player_new_mails[0].attached_items[1].Count set value 62b
execute if score @s dm_score matches 75..89 run data modify storage pld:system Temp_player_new_mails[0].attached_items[0].Count set value 11b
execute if score @s dm_score matches 75..89 run data modify storage pld:system Temp_player_new_mails[0].attached_items[1].Count set value 55b
execute if score @s dm_score matches ..54 run data modify storage pld:system Temp_player_new_mails[0].attached_items[0].Count set value 7b
execute if score @s dm_score matches ..54 run data modify storage pld:system Temp_player_new_mails[0].attached_items[1].Count set value 33b
execute in minecraft:overworld run function pld:system/chest_menu/screen/3_mails/get_mails/personal
execute if score @s {depth} = #settle dm_depth if score @s {depth} matches ..4 run scoreboard players add @s {depth} 1
tag @s add plm_clear_{d}
tellraw @s [{{"text":"{name}通关 · 镜评 "}},{{"score":{{"name":"@s","objective":"dm_score"}}}},{{"text":"。材料已寄个人邮箱。三枚同色镜片换镜心，影尘换镜片，倒影核换镜缘。"}}]
""",
    )
    function(
        d + "/abort",
        f'tellraw {players} {{"text":"{name}挑战结束，返回重华台。"}}\nfunction {base}/release',
    )
    function(
        d + "/recover",
        f"""
data modify storage plm:domains scanned set value []
data modify storage plm:domains scan set value []
data modify storage plm:domains scan set from storage plm:domains {d}_wins
execute if data storage plm:domains scan[0] run function {base}/check_receipt
function {base}/leave
""",
    )
    function(
        d + "/check_receipt",
        f"""
execute store result score #record dm_run run data get storage plm:domains scan[0].run
execute if score @s dm_run = #record dm_run unless score @s dm_paid = @s dm_run run function {base}/deliver
execute if score @s dm_paid = @s dm_run run return 0
data modify storage plm:domains scanned append from storage plm:domains scan[0]
data remove storage plm:domains scan[0]
execute if data storage plm:domains scan[0] run function {base}/check_receipt
""",
    )
    function(
        d + "/deliver",
        f"""
execute store result score #settle dm_age run data get storage plm:domains scan[0].age
execute store result score #settle dm_depth run data get storage plm:domains scan[0].depth
execute store result score #settle dm_deaths run data get storage plm:domains scan[0].deaths
function {base}/reward
execute store result score #pending dm_party run data get storage plm:domains scan[0].pending
scoreboard players remove #pending dm_party 1
execute store result storage plm:domains scan[0].pending int 1 run scoreboard players get #pending dm_party
execute if score #pending dm_party matches 1.. run data modify storage plm:domains scanned append from storage plm:domains scan[0]
data remove storage plm:domains scan[0]
data modify storage plm:domains scanned append from storage plm:domains scan[]
data modify storage plm:domains {d}_wins set from storage plm:domains scanned
""",
    )
    function(
        d + "/release",
        f"""
function {base}/cleanup
execute as {players} run function {base}/leave
scoreboard players reset {lock} dm_run
scoreboard players set {lock} dm_state 0
scoreboard players set {lock} dm_deaths 0
scoreboard players remove #slots dm_party 1
forceload remove {area}
kill @s
""",
    )
    function(
        d + "/leave",
        f"""
execute if data entity @s {{Health:0.0f}} run tag @s add plm_hub_respawn
tag @s remove {member}
tag @s remove plm_rescue
tag @s remove plm_enrolled
execute if entity @s[tag=plm_was_survival] run gamemode survival @s
tag @s remove plm_was_survival
execute in plm:domains run tp @s 16.5 64 16.5 180 0
""",
    )


if __name__ == "__main__":
    generate()
