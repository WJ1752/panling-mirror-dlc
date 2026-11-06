/* Run once against an explicitly selected disposable, loopback-only 1.20.1 server.
 * Reuses the existing Mineflayer install and RCON transport; no credentials in source.
 */
const fs = require('fs')
const path = require('path')
const assert = require('assert/strict')
const root = path.resolve(__dirname, '../../..')
const { Rcon } = require(path.join(root, '.work/weapon-phase1/test/rconlib.js'))
const mineflayer = require(path.join(root, '.work/bottools/node_modules/mineflayer'))
const server = path.resolve(process.argv[2] || '')
const specPath = process.argv.slice(3).find(arg => !arg.startsWith('--')) || path.join(__dirname, 'scenario.json')
const combatOnly = process.argv.includes('--combat-only')
const settlementOnly = process.argv.includes('--settlement-only')
const worldOnly = process.argv.includes('--world-only')
const refundOnly = process.argv.includes('--refund-only')
if (!process.argv[2]) throw Error('Usage: node run.cjs <isolated-server> [qa-coordinates.json]')
const props = Object.fromEntries(fs.readFileSync(path.join(server, 'server.properties'), 'utf8')
  .split(/\r?\n/).filter(s => s && !s.startsWith('#') && s.includes('='))
  .map(s => [s.slice(0, s.indexOf('=')), s.slice(s.indexOf('=') + 1)]))
assert.equal(props['server-ip'], '127.0.0.1', 'requires loopback isolation')
assert.equal(props['online-mode'], 'false', 'requires disposable offline world')
assert.notEqual(server, path.join(root, '梦回盘灵服务端'), 'never run on production')
const spec = JSON.parse(fs.readFileSync(specPath, 'utf8'))
const rcon = new Rcon('127.0.0.1', Number(props['rcon.port']), props['rcon.password'])
const send = async command => (await rcon.send(command)).replace(/§./g, '').trim()
const delay = ms => new Promise(resolve => setTimeout(resolve, ms))
const player = 'MirrorPilot'
let bot
let ally
const results = []
async function check(name, fn) {
  const detail = await fn()
  results.push({ name, pass: true, detail })
  console.log('PASS', name, JSON.stringify(detail))
}
async function score(holder, objective) {
  const text = await send(`scoreboard players get ${holder} ${objective}`)
  return Number((text.match(/has (-?\d+)/) || [0, NaN])[1])
}
async function until(fn, label, timeout = 7000) {
  const end = Date.now() + timeout
  while (Date.now() < end) { if (await fn()) return; await delay(100) }
  throw Error('timeout: ' + label)
}
async function test(command) {
  const result = await send(command)
  assert.match(result, /Test passed/, command + ' => ' + result)
}
async function tp(pos, name = player) {
  await send(`execute in minecraft:overworld run tp ${name} ${pos.join(' ')}`)
  await delay(450)
  const client = name === player ? bot : ally
  if (client) await Promise.race([client.waitForChunksToLoad(), delay(2000)])
}
async function interact(tag, name = player, client = bot) {
  const pos = await send(`execute in minecraft:overworld run data get entity @e[tag=${tag},limit=1] Pos`)
  const coords = pos.match(/\[([^\]]+)\]/)
  assert.ok(coords, 'missing interaction ' + tag + ': ' + pos)
  const [x, y, z] = coords[1].split(',').map(n => Number(n.trim().replace(/d$/, '')))
  await tp([x, y, z - 2], name)
  const entity = await (async () => {
    let found
    await until(() => {
      found = Object.values(client.entities).find(e => e.name === 'interaction' &&
        Math.abs(e.position.x - x) < 1 && Math.abs(e.position.z - z) < 1)
      return !!found
    }, tag)
    return found
  })()
  await client.lookAt(entity.position.offset(0, 0.6, 0), true)
  await client.activateEntity(entity)
  await delay(350)
}
async function trade(index) {
  await send(`execute as ${player} if entity @s[tag=${spec.memberTag}] run function plm:shadow/leave`)
  await tp(spec.merchantApproach)
  let villager
  await until(() => {
    villager = Object.values(bot.entities).find(e => e.name === 'villager' &&
      e.position.distanceTo(bot.entity.position) < 5)
    return !!villager
  }, 'city merchant')
  await bot.lookAt(villager.position.offset(0, 1.4, 0), true)
  const window = await bot.openVillager(villager)
  const trading = bot.trade(window, index, 1)
  await Promise.race([trading, delay(4000)])
  if (bot.currentWindow) bot.closeWindow(bot.currentWindow)
  await delay(500)
}
async function main() {
  await rcon.connect()
  bot = mineflayer.createBot({ host: '127.0.0.1', port: Number(props['server-port']),
    username: player, version: '1.20.1', auth: 'offline', hideErrors: true })
  await new Promise((resolve, reject) => {
    bot.once('spawn', resolve); bot.once('error', reject)
    bot.once('kicked', reason => reject(Error(String(reason))))
  })
  bot.on('error', err => console.error('client', err.message))
  await delay(700)
  await send(`gamemode adventure ${player}`)
  await send(`effect give ${player} resistance 300 4 true`)
  await send(`effect give ${player} saturation 300 0 true`)
  await send(`clear ${player}`)
  await send(`scoreboard players set ${player} mirror_shadow_lord_done 0`)
  if (combatOnly || settlementOnly) return runCombat()
  if (worldOnly) return runWorld()
  if (refundOnly) return runRefund()
  // The task-specific checks below use real NPC trades/interactions for entry;
  // controlled damage/HP is explicitly reported as accelerated combat validation.
  await check('world installation ready', async () => {
    for (const command of spec.installChecks) await test(command)
    return spec.installChecks.length
  })
  await check('ordinary material cannot purchase passage', async () => {
    await tp(spec.merchantApproach)
    await send(`give ${player} iron_ingot 1`)
    const villager = Object.values(bot.entities).find(e => e.name === 'villager' &&
      e.position.distanceTo(bot.entity.position) < 5)
    assert.ok(villager, 'visible city merchant')
    const window = await bot.openVillager(villager)
    let rejected = false
    try {
      await Promise.race([bot.trade(window, spec.payments[1].tradeIndex, 1),
        delay(2000).then(() => { throw Error('server refused invalid currency') })])
    }
    catch { rejected = true }
    if (bot.currentWindow) bot.closeWindow(bot.currentWindow)
    assert.ok(rejected, 'plain iron trade must be refused')
    await test(`execute as ${player} unless entity @s[tag=${spec.memberTag}]`)
    const remaining = await send(`clear ${player} iron_ingot 0`)
    assert.match(remaining, /Found 1 matching item/)
    return 'plain iron refused; inventory preserved'
  })
  await check('unpaid walking entry returns to the main city', async () => {
    await tp(spec.town)
    await until(async () => /Test passed/.test(await send(
      `execute as ${player} at @s if entity @s[x=175,y=40,z=15,dx=10,dy=8,dz=12]`)), 'unpaid visitor return')
    await test(`execute as ${player} unless entity @s[tag=${spec.memberTag}]`)
    return 'map boundary enforces the NPC entrance'
  })
  for (const payment of spec.payments) {
    await check('real merchant trade: ' + payment.name, async () => {
      await send(`clear ${player}`)
      await send(`give ${player} ${payment.item} 2`)
      await trade(payment.tradeIndex)
      await until(async () => /Test passed/.test(await send(
        `execute as ${player} if entity @s[tag=${spec.memberTag}]`)), 'paid entry')
      await test(`execute as ${player} at @s if entity @s[x=${spec.town[0]-8},y=${spec.town[1]-3},z=${spec.town[2]-8},dx=16,dy=8,dz=16]`)
      const remaining = await send(`clear ${player} ${payment.match} 0`)
      assert.match(remaining, /Found 1 matching item/, 'one payment only: ' + remaining)
      await interact(spec.exitTag)
      await test(`execute as ${player} unless entity @s[tag=${spec.memberTag}]`)
      return 'one item consumed; safe town arrival and return'
    })
  }
  await runRefund()
  await runWorld()
  if (spec.combat) await runCombat()
}
async function runRefund() {
  await check('blocked landing refunds the exact NPC payment', async () => {
    await send(`execute as ${player} run function plm:shadow/leave`)
    await send(`clear ${player}`)
    await send(`give ${player} ${spec.payments[0].item} 1`)
    const [x, y, z] = spec.town.map(Math.floor)
    await send(`setblock ${x} ${y} ${z} minecraft:stone`)
    try {
      await trade(0)
      await test(`execute as ${player} unless entity @s[tag=${spec.memberTag}]`)
      assert.match(await send(`clear ${player} ${spec.payments[0].match} 0`), /Found 1 matching item/)
    } finally {
      await send(`setblock ${x} ${y} ${z} minecraft:air`)
    }
    return 'blocked town landing refused; the one paid dust was restored'
  })
}
async function runWorld() {
  await send(`give ${player} ${spec.payments[0].item} 1`)
  await trade(0)
  await check('town workbench preserves an occupied output and materials', async () => {
    const at = 'execute at @e[tag=plm_shadow_forge,type=marker,limit=1] run '
    await send(at + 'data modify block ~ ~ ~ Items set value [{Slot:0b,id:"minecraft:gunpowder",Count:10b,tag:{id:"panling:mirror_dust",CustomModelData:390}},{Slot:5b,id:"minecraft:diamond",Count:1b}]')
    await interact('plm_shadow_forge_use')
    await test(at + 'execute if data block ~ ~ ~ Items[{Slot:5b,id:"minecraft:diamond",Count:1b}]')
    await test(at + 'execute if data block ~ ~ ~ Items[{Slot:0b,Count:10b}]')
    // The cooldown confirms the actual interaction reached the existing table.
    assert.ok(await score(player, 'mirror_tbl_cool') > 0)
    await send(at + 'data modify block ~ ~ ~ Items set value []')
    return 'real click; occupied output and all ten dust retained'
  })
  await check('ruin mobs spawn with natural mob spawning disabled', async () => {
    await send('gamerule doMobSpawning false')
    await send('execute store success score #qa_ticket shadow_tmp run forceload add -631 -1400')
    await tp([-630.5, 177, -1419.5])
    await send('scoreboard players set @e[tag=plm_shadow_wilderness_spawn] shadow_spawn_cd 0')
    await until(async () => /Test passed/.test(await send('execute if entity @e[tag=plm_shadow_wild]')), 'wildlife spawn', 10000)
    const count = await score('#shadow', 'shadow_mob_count')
    assert.ok(count >= 1 && count <= 45, 'shared cap: ' + count)
    await send(`damage @e[tag=plm_shadow_wild,limit=1,sort=nearest] 200 minecraft:player_attack by ${player}`)
    await send(`loot give ${player} loot plm:shadow/dust`)
    await test(`execute if data entity ${player} Inventory[{id:"minecraft:gunpowder",tag:{id:"panling:mirror_dust",CustomModelData:390}}]`)
    return { liveMobs: count, note: 'actual player-source kill; canonical loot table verified; random 5% roll is not forced' }
  })
  await check('unattended wilderness packs are reclaimed', async () => {
    await send(`execute as ${player} run function plm:shadow/town_return`)
    await until(async () => /Test passed/.test(await send('execute unless entity @e[tag=plm_shadow_wild]')), 'unattended cleanup', 7000)
    await send('execute if score #qa_ticket shadow_tmp matches 1 run forceload remove -631 -1400')
    await interact(spec.exitTag)
    return 'loaded ruin reclaimed after leaving its 64-block activity radius'
  })
}
async function runCombat() {
  // Entry is purchased through the actual NPC again. The second participant's
  // admission tag is fixture setup; their queue interaction uses a real client.
  await send(`give ${player} ${spec.payments[0].item} 1`)
  await trade(0)
  for (const step of spec.combat.setup || []) await send(step.replaceAll('{player}', player))
  const allyName = 'ShadowAlly'
  async function connectAlly() {
    const client = mineflayer.createBot({ host: '127.0.0.1', port: Number(props['server-port']),
      username: allyName, version: '1.20.1', auth: 'offline', hideErrors: true })
    await new Promise((resolve, reject) => { client.once('spawn', resolve); client.once('error', reject) })
    client.on('error', err => console.error('ally', err.message))
    return client
  }
  ally = await connectAlly()
  await send(`scoreboard players set ${allyName} mirror_shadow_lord_done 0`)
  await send(`gamemode adventure ${allyName}`)
  await send(`effect give ${allyName} resistance 300 4 true`)
  await send(`tag ${allyName} add ${spec.memberTag}`)
  await send(`scoreboard players add ${allyName} shadow_died 0`)
  await send(`scoreboard players operation ${allyName} shadow_died_seen = ${allyName} shadow_died`)
  await send(`scoreboard players add ${allyName} mirror_leave 0`)
  await send(`scoreboard players operation ${allyName} shadow_leave_seen = ${allyName} mirror_leave`)
  await tp(spec.town, allyName)
  await interact(spec.combat.joinTag, allyName, ally)
  await check('boss portal starts a real encounter', async () => {
    await interact(spec.combat.portalTag)
    await until(async () => await score('#arena', 'mirror_arena_active') === 1, 'boss admission')
    await test(`execute as ${allyName} if entity @s[tag=mirror_arena_member]`)
    assert.equal(await score('#arena', 'mirror_arena_party'), 2)
    assert.equal(await score('#boss', 'mirror_boss_max'), 840)
    return { phase: await score('#arena', 'mirror_boss_phase'), hp: await score('#boss', 'mirror_boss_hp') }
  })
  if (!settlementOnly) {
  await check('real sword subtracts boss HP', async () => {
    const [x, y, z] = spec.combat.arrowPosition
    await tp([x, y, z - 7.4])
    await send(`item replace entity ${player} weapon.mainhand with minecraft:diamond_sword`)
    await delay(700)
    const boss = Object.values(bot.entities).find(e => e.name === 'husk' && e.position.distanceTo(bot.entity.position) < 10)
    assert.ok(boss, 'visible boss hitbox')
    const before = await score('#boss', 'mirror_boss_hp')
    await bot.lookAt(boss.position.offset(0, 1.2, 0), true)
    bot.attack(boss)
    // The base map reduces a level-zero vanilla weapon to sub-HP scripted
    // damage. Multiple real swings must accumulate that retained fraction.
    for (let swing = 1; swing < 4 && await score('#boss', 'mirror_boss_hp') === before; swing++) {
      await delay(700)
      bot.attack(boss)
    }
    try { await until(async () => await score('#boss', 'mirror_boss_hp') < before, 'real sword HP') }
    catch (err) {
      console.error('hit diagnostics', await send(`data get entity ${player} Pos`),
        await send(`data get entity ${player} Tags`), await send(`data get entity ${player} SelectedItem`),
        await score(player, 'mirror_abs_dealt'), await score(player, 'mirror_abs_seen'),
        await score('#hit', 'mirror_boss_damage'))
      throw err
    }
    return { before, after: await score('#boss', 'mirror_boss_hp') }
  })
  await check('real arrow triggers mirror lord without HP debit', async () => {
    const before = await score('#boss', 'mirror_boss_hp')
    await send(`item replace entity ${player} weapon.mainhand with minecraft:bow`)
    await send(`give ${player} arrow 8`)
    await tp(spec.combat.arrowPosition)
    await delay(650)
    const boss = Object.values(bot.entities).find(e => e.name === 'husk' && e.position.distanceTo(bot.entity.position) < 20)
    assert.ok(boss, 'visible archery target')
    await bot.lookAt(boss.position.offset(0, 1.3, 0), true)
    bot.activateItem(); await delay(1250); bot.deactivateItem()
    await until(async () => await score('#arena', 'mirror_boss_phase') === 2, 'real arrow transformation')
    assert.equal(await score('#boss', 'mirror_boss_hp'), before)
    return { before, phase: 2 }
  })
  await check('forbidden kill branch restores exactly two percent', async () => {
    await send('scoreboard players set #boss mirror_boss_hp 700')
    await send('execute at @e[tag=mirror_arena_anchor,limit=1] run function plm:arena/event/heal_forbidden')
    assert.equal(await score('#boss', 'mirror_boss_hp'), 716)
    return 'controlled event branch: 700 -> 716 at max HP 840'
  })
  }
  async function mails() {
    // RCON's inherited transport returns only the first response packet. Build
    // short, owner-filtered counts in server storage instead of parsing a huge
    // global mail dump, which can omit newly appended mail at the end.
    await send('data modify storage plm:shadow_qa mails set value []')
    for (const name of [player, allyName]) {
      const uid = await score(name, 'player_uid')
      if (Number.isFinite(uid)) await send(`data modify storage plm:shadow_qa mails append from storage pld:system pending_mails[{owner:${uid}}].mails[]`)
      await send(`data modify storage plm:shadow_qa mails append from entity ${name} EnderItems[{Slot:0b}].tag.data.mails[]`)
    }
    const counts = {}
    for (const [key, title] of [['first', '影主首通 · 倒影核'], ['repeat', '影主再战 · 倒影核']]) {
      await send('data modify storage plm:shadow_qa selected set value []')
      const component = JSON.stringify({ text: title })
      await send(`data modify storage plm:shadow_qa selected append from storage plm:shadow_qa mails[{title:'${component}'}]`)
      await send('execute store result score #qa_mail shadow_tmp run data get storage plm:shadow_qa selected')
      counts[key] = await score('#qa_mail', 'shadow_tmp')
    }
    return counts
  }
  let beforeWin, winningRun
  await check('half-health transition', async () => {
    await send('scoreboard players set #boss mirror_boss_hp 400')
    await until(async () => await score('#arena', 'mirror_boss_phase') === 3, 'reflection phase')
    return 3
  })
  await check('accelerated final phase, victory and offline receipt', async () => {
    beforeWin = await mails()
    winningRun = await score('#arena', 'mirror_arena_run')
    ally.quit(); ally = null
    await delay(350)
    await send('scoreboard players set #boss mirror_boss_hp 200')
    await until(async () => await score('#arena', 'mirror_boss_phase') === 4, 'final phase')
    await send('scoreboard players set #boss mirror_boss_hp 0')
    await until(async () => await score('#arena', 'mirror_arena_active') === 0, 'victory clean up')
    await test(`execute as ${player} if entity @s[tag=${spec.memberTag}]`)
    assert.equal(await score(player, 'mirror_shadow_lord_done'), 1)
    const after = await mails()
    assert.equal(after.first - beforeWin.first, 1, 'one first-clear mail for online player')
    assert.equal(after.repeat, beforeWin.repeat, 'no duplicate repeat mail on first clear')
    await test('execute if data storage plm:arena receipts[{pending:1}]')
    return 'controlled HP acceleration; one mail now and one offline receipt'
  })
  await check('offline reward recovers once on reconnection', async () => {
    const before = await mails()
    ally = await connectAlly()
    await until(async () => await score(allyName, 'mirror_arena_paid') === winningRun, 'offline reward for this run')
    const after = await mails()
    assert.equal(after.first + after.repeat - before.first - before.repeat, 1)
    await send(`execute as ${allyName} run function plm:arena/reward/recover`)
    await send(`execute as ${allyName} run function plm:arena/reward/recover`)
    assert.deepEqual(await mails(), after)
    await test('execute unless data storage plm:arena receipts[0]')
    return 'reconnected teammate paid exactly once; receipt removed'
  })
  await check('failure releases the room without awarding a victory', async () => {
    const before = await mails()
    await interact(spec.combat.portalTag)
    await until(async () => await score('#arena', 'mirror_arena_active') === 1, 'reopen')
    await send('kill @e[tag=mirror_arena_boss,limit=1]')
    await until(async () => await score('#arena', 'mirror_arena_active') === 0, 'abort')
    assert.deepEqual(await mails(), before)
    return 'missing hitbox aborts; no victory mail'
  })
  await check('actual team wipe respawns in town and permits a restart', async () => {
    const before = await mails()
    await interact(spec.combat.portalTag)
    await until(async () => await score('#arena', 'mirror_arena_active') === 1, 'wipe fixture')
    bot.once('death', () => setTimeout(() => bot.respawn(), 150))
    await send(`kill ${player}`)
    await until(async () => await score('#arena', 'mirror_arena_active') === 0 && bot.health > 0,
      'death and respawn', 10000)
    await test(`execute as ${player} at @s if entity @s[tag=${spec.memberTag},x=-724,y=194,z=-1474,dx=38,dy=30,dz=39]`)
    assert.deepEqual(await mails(), before)
    return 'real player death, automatic town recovery, no victory payment'
  })
  await check('repeat challenge rewards once and returns to town', async () => {
    const before = await mails()
    await interact(spec.combat.portalTag)
    await until(async () => await score('#arena', 'mirror_arena_active') === 1, 'repeat challenge')
    await send('scoreboard players set #boss mirror_boss_hp 0')
    await until(async () => await score('#arena', 'mirror_arena_active') === 0, 'repeat victory')
    const after = await mails()
    assert.equal(after.repeat - before.repeat, 1)
    assert.equal(after.first, before.first)
    await test(`execute as ${player} if entity @s[tag=${spec.memberTag}]`)
    return 'one repeat mail; admission retained for farming'
  })
  await check('explicit departure forfeits the current boss reward', async () => {
    const before = await mails()
    await interact(spec.combat.joinTag, allyName, ally)
    await interact(spec.combat.portalTag)
    await until(async () => await score('#arena', 'mirror_arena_active') === 1, 'forfeit fixture')
    assert.equal(await score('#arena', 'mirror_arena_party'), 2)
    await send(`execute as ${allyName} run function plm:shadow/leave`)
    assert.equal(await score('#arena', 'mirror_arena_party'), 1)
    assert.equal(await score(allyName, 'mirror_arena_run'), 0)
    await send('scoreboard players set #boss mirror_boss_hp 0')
    await until(async () => await score('#arena', 'mirror_arena_active') === 0, 'remaining player victory')
    const after = await mails()
    assert.equal(after.first + after.repeat - before.first - before.repeat, 1)
    await test('execute unless data storage plm:arena receipts[0]')
    return 'only the remaining participant is paid; no ghost receipt'
  })
}
main().catch(err => {
  results.push({ name: 'failure', pass: false, detail: err.stack })
  console.error(err); process.exitCode = 1
}).finally(async () => {
  fs.writeFileSync(path.join(server, 'shadow-qa-results.json'), JSON.stringify(results, null, 2))
  if (bot) bot.quit()
  if (ally) ally.quit()
  rcon.close()
  setTimeout(() => process.exit(process.exitCode || 0), 300)
})
