_ = require 'underscore'

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

  msgId = (user, session) ->
    date = new Date().getTime()
    session = session || 0
    '' + session + user.id + date + counter


  socketWrapper =
    onmessage: (json) -> console.log json
    ping: ->
      o = id: msgId user, type: 'ping'
      socket.send JSON.stringify o
    send: (messages, callback) ->
      for message in messages
        message.id = msgId user, message.session
        counter++
      socket.send JSON.stringify messages
      checkSend = (t) ->
        if socket.readyState isnt 1
          callback true
        else if socket.bufferedAmount is 0
          callback false
        else return true
        clearInterval t if t
        false

      if checkSend()
        interval = setInterval ((o) -> checkSend interval), 100

  extras =
    onopen: ->
      console.log 'Connection is opened and ready to use'
      # Do auth
      id = msgId user
      authObject = messages: [ id: id, type: 'handshake', data: user: user ]
      console.log 'AUTH OBJECT', authObject
      socket.send JSON.stringify authObject
    onclose: ->
      reconnect()
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