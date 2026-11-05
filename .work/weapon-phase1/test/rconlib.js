'use strict'
// Minimal RCON client (same framing as test/rcon.py).
const net = require('net')
const fs = require('fs')
const path = require('path')

function testPassword() {
  if (process.env.PLM_TEST_RCON_PASSWORD) return process.env.PLM_TEST_RCON_PASSWORD
  const props = path.resolve(__dirname, '../../weapon-test/server/server.properties')
  if (fs.existsSync(props)) {
    const match = fs.readFileSync(props, 'utf8').match(/^rcon\.password=(.+)$/m)
    if (match && match[1].trim()) return match[1].trim()
  }
  throw new Error('Set PLM_TEST_RCON_PASSWORD or configure the local test server.properties')
}

function pkt(id, type, payload) {
  const body = Buffer.concat([Buffer.from(payload, 'utf8'), Buffer.from([0, 0])])
  const head = Buffer.alloc(12)
  head.writeInt32LE(body.length + 8, 0)
  head.writeInt32LE(id, 4)
  head.writeInt32LE(type, 8)
  return Buffer.concat([head, body])
}

class Rcon {
  constructor(host = '127.0.0.1', port = 25591, password = testPassword()) {
    this.host = host
    this.port = port
    this.password = password
    this.sock = null
    this.buf = Buffer.alloc(0)
    this.nextId = 2
  }

  connect() {
    return new Promise((resolve, reject) => {
      const sock = net.connect(this.port, this.host)
      sock.setTimeout(20000)
      sock.once('connect', () => {
        sock.write(pkt(1, 3, this.password))
      })
      sock.on('data', (d) => {
        this.buf = Buffer.concat([this.buf, d])
        this._drain()
      })
      sock.once('error', (e) => reject(e))
      sock.once('timeout', () => reject(new Error('rcon timeout')))
      this._authResolve = resolve
      this._authReject = reject
      this.sock = sock
    })
  }

  _drain() {
    while (this.buf.length >= 4) {
      const len = this.buf.readInt32LE(0)
      if (this.buf.length < 4 + len) return
      const body = this.buf.subarray(4, 4 + len)
      this.buf = this.buf.subarray(4 + len)
      const id = body.readInt32LE(0)
      const type = body.readInt32LE(4)
      const payload = body.subarray(8, body.length - 2).toString('utf8')
      if (id === 1) {
        if (this._authResolve) {
          const r = this._authResolve
          this._authResolve = null
          this._authReject = null
          r()
        }
        continue
      }
      if (this._pending && this._pending.id === id) {
        const p = this._pending
        this._pending = null
        p.resolve(payload)
      }
    }
  }

  send(cmd) {
    return new Promise((resolve, reject) => {
      if (!this.sock) return reject(new Error('not connected'))
      const id = this.nextId++
      this._pending = { id, resolve, reject }
      this.sock.write(pkt(id, 2, cmd))
    })
  }

  close() {
    if (this.sock) this.sock.destroy()
  }
}

module.exports = { Rcon }
