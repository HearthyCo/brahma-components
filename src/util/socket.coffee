_ = require 'underscore'
SocketUtils = require '../util/socketUtils'
EntityStores = require '../stores/EntityStores'

defaults =
  hostname: 'localhost'
  port: 1337
  timeout: 2000

module.exports = (usr, opts) ->
  user = usr
  opts = opts || {}
  _.defaults opts, defaults

  connect = ->
    new WebSocket 'ws://' + opts.hostname + ':' + opts.port

  socket = connect()

  reconnect = ->
    console.log 'Connection closed, restart in', (opts.timeout/1000), 'seconds'
    setTimeout(( ->
      socket = _.extend connect(), extras
    ), opts.timeout)

  checkSend = (callback, t) ->
    if socket.readyState isnt 1
      callback true
    else if socket.bufferedAmount is 0
      callback false
    else return true
    clearInterval t if t
    false

  socketWrapper =
    onmessage: (json) -> console.log json
    ping: ->
      id = SocketUtils.mkMessageId user.id
      ping = id: id, type: 'ping', data: message: 'Ping'
      socket.send JSON.stringify ping
      if checkSend()
        callback = ->
          console.log 'Ping sent'
        interval = setInterval ((o) -> checkSend(callback, interval)), 100
    send: (messages, callback) ->
      socket.send JSON.stringify messages
      if checkSend()
        interval = setInterval ((o) -> checkSend(callback, interval)), 100
    updateSessions: ->
      session = [
        id: SocketUtils.mkMessageId user.id
        type: 'session'
        data:
          sessions: EntityStores.SignedEntry.get('sessions').value
          _sessions_sign: EntityStores.SignedEntry.get('sessions').signature
      ]
      socket.send JSON.stringify session

  extras =
    onopen: ->
      console.log 'Connection is opened and ready to use'
      # Do auth
      handshake = [
        id: SocketUtils.mkMessageId user.id
        type: 'handshake'
        data:
          userId: EntityStores.SignedEntry.get('userId').value
          _userId_sign: EntityStores.SignedEntry.get('userId').signature
          sessions: EntityStores.SignedEntry.get('sessions').value
          _sessions_sign: EntityStores.SignedEntry.get('sessions').signature
      ]
      socket.send JSON.stringify handshake
      callback = ->
        console.log 'Auth sent'
      if checkSend()
        interval = setInterval ((o) -> checkSend(callback, interval)), 100
    onclose: ->
      reconnect()
    onerror: (error) ->
      console.log 'An error occurred when sending/receiving data', error
    onmessage: (message) ->
      try
        data = JSON.parse message.data
      catch e
        console.log 'This doesn\'t look like a valid JSON: ', message.data, e

      socketWrapper.onmessage data

  _.extend socket, extras
  socketWrapper