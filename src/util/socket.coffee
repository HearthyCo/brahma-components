_ = require 'underscore'
SocketUtils = require '../util/socketUtils'

defaults =
  hostname: 'localhost'
  port: 1337
  timeout: 2000

module.exports = (usr, opts) ->
  counter = 0
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
      id = SocketUtils.mkMessageId user.id, counter
      o = id: id, type: 'ping'
      socket.send JSON.stringify o
      if checkSend()
        callback = ->
          console.log 'Ping done'
        interval = setInterval ((o) -> checkSend(callback, interval)), 100
    send: (messagesList, callback) ->
      for messages in messagesList
        for message in messages
          message.id = SocketUtils.mkMessageId user.id, counter, message.session
          counter++
        console.log 'MESSAGES', messages
      socket.send JSON.stringify messagesList
      if checkSend()
        interval = setInterval ((o) -> checkSend(callback, interval)), 100

  extras =
    onopen: ->
      console.log 'Connection is opened and ready to use'
      # Do auth
      id = SocketUtils.mkMessageId user.id, counter
      authObject = messages: [ id: id, type: 'handshake', data: user: user ]
      console.log 'AUTH OBJECT', authObject
      socket.send JSON.stringify authObject
      callback = ->
        console.log 'Auth done'
      if checkSend()
        interval = setInterval ((o) -> checkSend(callback, interval)), 100
    onclose: ->
      reconnect()
    onerror: (error) ->
      console.log 'An error occurred when sending/receiving data', error
    onmessage: (message) ->
      try
        socketWrapper.onmessage JSON.parse message.data
      catch e
        console.log 'This doesn\'t look like a valid JSON: ', message.data

  _.extend socket, extras
  socketWrapper