_ = require 'underscore'
SocketUtils = require '../util/socketUtils'
EntityStores = require '../stores/EntityStores'

defaults =
  hostname: 'localhost'
  port: 1337
  timeout: 2000

module.exports = (usr, opts) ->
  user = usr
  opts = opts or {}
  _.defaults opts, defaults

  url = opts.hostname
  url = opts.hostname + ':' + opts.port if opts.port
  url = 'ws://' + url

  connect = ->
    new window.WebSocket url

  socket = connect()

  # pre-define
  extras = {}

  reconnect = ->
    console.log 'Connection closed, restart in', (opts.timeout/1000), 'seconds'
    window.setTimeout(( ->
      ###coffeelint-variable-scope-ignore###
      socket = _.extend connect(), extras
    ), opts.timeout)

  # Checks if messages have been sent
  # Return: [bool] still waiting
  checkSend = (callback, t) ->
    # Socket not ready
    if socket.readyState isnt 1
      callback true if callback # call err
    # Buffer empty
    else if socket.bufferedAmount is 0
      callback false if callback # call success (!err)
    else
      return true # Socket ready and buffer has something, keep waiting

    # Done, stop waiting
    if t
      window.clearInterval t

    # Done
    return false

  socketWrapper =
    onmessage: (json) -> console.log json
    ping: ->
      id = SocketUtils.mkMessageId user.id
      ping = id: id, type: 'ping', data: message: 'Ping'
      socket.send JSON.stringify ping
      if checkSend()
        callback = ->
          console.log 'Ping sent'
        interval = window.setInterval (-> checkSend(callback, interval)), 100
    send: (messages, callback) ->
      socket.send JSON.stringify messages
      if checkSend()
        interval = window.setInterval (-> checkSend(callback, interval)), 100
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
          userRole: EntityStores.SignedEntry.get('userRole').value
          _userRole_sign: EntityStores.SignedEntry.get('userRole').signature
          sessions: EntityStores.SignedEntry.get('sessions')?.value
          _sessions_sign: EntityStores.SignedEntry.get('sessions')?.signature
      ]
      socket.send JSON.stringify handshake
      callback = ->
        console.log 'Auth sent'
      if checkSend()
        interval = window.setInterval (-> checkSend(callback, interval)), 100
    onclose: ->
      reconnect()
    onerror: (error) ->
      console.log 'An error occurred when sending/receiving data', error
    onmessage: (message) ->
      try
        data = JSON.parse message.data
      catch ex
        console.log 'This doesn\'t look like a valid JSON: ', message.data, ex

      socketWrapper.onmessage data

  _.extend socket, extras
  socketWrapper