_ = require 'underscore'

defaults =
  hostname: 'localhost'
  port: 1337
  timeout: 2000

module.exports = (user, opts) ->
  counter = 0
  _.defaults opts || {}, defaults

  connect = ->
    new WebSocket 'ws://' + opts.hostname + ':' + opts.port

  reconnect = ->
    console.log 'Connection closed, restart in', (opts.timeout/1000), 'seconds'
    setTimeout connect(), opts.timeout

  msgId = (user, session) ->
  date = new Date().getTime()
  session = session || 0
  '' + session + user.id + date + counter

  socket = connect()

  socketWrapper =
    onmessage: (json) -> console.log json
    ping: ->
      o = id: msgId user, type: 'ping'
      socket.send JSON.stringify o
    send: (messages) ->
      for message in messages
        console.log 'CHECK MESSAGE', message
        message.id = msgId user, message.session
        socket.send JSON.stringify messages
        counter++

  extras =
    onopen: ->
      console.log 'Connection is opened and ready to use'
      # Do auth
      authObject = messages: id: msgId user, type: 'handshake', data: user: user
      socket.send JSON.stringify authObject
    onclose: ->
      socket = _.extend reconnect(), extras
    onerror: (error) ->
      console.log 'An error occurred when sending/receiving data', error
    onmessage: (message) ->
      try
        json = JSON.parse message.data
        socketWrapper.onmessage json
      catch e
        console.log 'This doesn\'t look like a valid JSON: ', message.data

  _.extend socket, extras
  socketWrapper