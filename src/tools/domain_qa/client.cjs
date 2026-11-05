'use strict'
const fs = require('fs')
const mineflayer = require('mineflayer')
const { Vec3 } = require('vec3')

const delay = ms => new Promise(resolve => setTimeout(resolve, ms))

async function interact(bot, request) {
  const position = new Vec3(request.x, request.y, request.z)
  const type = request.mode === 'boss' ? 'husk' : 'interaction'
  for (let attempt = 0; attempt < 35; attempt++) {
    const target = Object.values(bot.entities).find(entity =>
      entity.name === type && entity.position.distanceTo(position) < 1.35
    )
    if (target) {
      await bot.lookAt(target.position.offset(0, 0.65, 0), true)
      if (request.mode === 'click') {
        await bot.activateEntity(target)
      } else {
        bot.attack(target)
      }
      return
    }
    await delay(100)
  }
  throw new Error(`Missing ${type} at ${position}, player at ${bot.entity.position}`)
}

async function main() {
  const bot = mineflayer.createBot({
    host: '127.0.0.1',
    port: Number(process.argv[2]),
    version: '1.20.1',
    auth: 'offline',
    username: 'MirrorPilot'
  })
  await new Promise((resolve, reject) => {
    bot.once('spawn', resolve)
    bot.once('error', reject)
  })
  bot.on('error', console.error)
  bot.once('end', () => process.exit(0))

  // A private temporary directory carries requests from the RCON fixture driver.
  for (;;) {
    if (fs.existsSync('domains-action.json')) {
      const request = JSON.parse(fs.readFileSync('domains-action.json', 'utf8'))
      fs.unlinkSync('domains-action.json')
      const response = { id: request.id }
      try {
        await interact(bot, request)
        response.ok = true
      } catch (error) {
        response.error = String(error)
      }
      fs.writeFileSync('domains-response.tmp', JSON.stringify(response))
      fs.renameSync('domains-response.tmp', 'domains-response.json')
    }
    await delay(30)
  }
}

main().catch(error => {
  console.error(error)
  process.exit(1)
})
