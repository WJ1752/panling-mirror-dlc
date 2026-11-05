'use strict'
// 六器形冒烟入口：设置 NODE_PATH 后直接 require combat.js。
// combat.js 自己会 process.exit(0/1/2)，这里不拦截，退出码原样透传。
const path = require('path')
const Module = require('module')

process.env.NODE_PATH = path.resolve(__dirname, '..', '..', 'bottools', 'node_modules')
Module._initPaths()

require('./combat.js')
