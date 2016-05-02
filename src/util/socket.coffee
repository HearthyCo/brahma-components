_ = require 'underscore'
SocketUtils = require '../util/socketUtils'
EntityStores = require '../stores/EntityStores'
AppDispatcher = require '../dispatcher/AppDispatcher'

defaults =
  hostname: 'localhost'
  port: 1337
  timeout: 2000

module.exports = (usr, opts) ->
  user = usr
  opts = opts or {}
  _.defaults opts, defaults

  if opts.url
    url = opts.url
  else
    url = opts.hostname
    url = opts.hostname + ':' + opts.port if opts.port
    url = 'ws://' + url

  # pre-define
  socketWrapper = null

  connect = ->
    try
      sock = new window.WebSocket url
    catch ex
      # console.log "Connection unavailable", ex
      socketWrapper.onerror ex

    return sock

  socket = connect()

  # pre-define
  extras = {}

  reconnect = ->
    console.log '> Connection closed, restart in',
      (opts.timeout/1000), 'seconds'
    window.setTimeout(( ->
      ###coffeelint-variable-scope-ignore###
      socket = _.extend connect(), extras
    ), opts.timeout)


  # Checks if messages have been sent
  # Return: [bool] still waiting
  checkSend = (callback, timer) ->
    retry = true
    if socket.readyState isnt window.WebSocket.OPEN
      # Socket not ready
      # console.log "> check: Socket not ready"
      callback true if callback # call err
      retry = true
    else if socket.bufferedAmount is 0
      # Buffer empty, message sent
      # console.log "> check: Buffer empty"
      callback false if callback # call success (!err)
      retry = false
    else
      # Socket ready and buffer has something, keep waiting
      # console.log "> check: Retrying delivery"
      retry = true

    # Done, stop waiting
    if not retry and timer
      # console.log "> check: Clearing timer #{timer} with retry #{retry}"
      window.clearInterval timer

    # Callback called
    # if callback
      # console.log "> check: Retry", retry, "with callback", callback

    return retry

  # Default callbacks
  socketWrapper =
    onmessage: (json) -> console.log "> onMessage", json
    onerror: (error) ->
      console.log "> onError", error
      AppDispatcher.trigger 'user:Socket:error', error: error
    onclose: (code) ->
      console.log "> onClose", code
      AppDispatcher.trigger 'user:Socket:close', code: code
    onopen: ->
      console.log "> onOpen"
      AppDispatcher.trigger 'user:Socket:open', {}
    onauth: -> console.log "> onAuth"
    onping: -> console.log "> onPing"

    ping: ->
      id = SocketUtils.mkMessageId user.id
      ping = id: id, type: 'ping', data: message: 'Ping'
      socket.send JSON.stringify ping
      if checkSend()
        interval = window.setInterval (->
          checkSend socketWrapper.onping, interval
        ), 100

    send: (messages, callback) ->
      err = false
      try
        socket.send JSON.stringify messages
      catch ex
        console.log "> Send exception:", ex
        callback true if callback
        return

      if checkSend()
        interval = window.setInterval (-> checkSend(callback, interval)), 100

      # console.log 'Sending', messages, SocketUtils.socketDebug(socket)

    isReady: ->
      return (socket.readyState is window.WebSocket.OPEN)

    close: ->
      socket.close()

  extras =
    onopen: ->
      socketWrapper.onopen() if socketWrapper.onopen
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
      if checkSend()
        interval = window.setInterval (->
          checkSend socketWrapper.onauth, interval
        ), 100
    onclose: (code) ->
      socketWrapper.onclose code if socketWrapper.onclose
      reconnect() if not code.wasClean
    onerror: (error) ->
      socketWrapper.onerror error if socketWrapper.onerror
    onmessage: (message) ->
      # console.log "> Message received"
      try
        data = JSON.parse message.data
      catch ex
        console.log '> This doesn\'t look like a valid JSON: ',
          message.data, ex

      socketWrapper.onmessage data if socketWrapper.onmessage

  # Extend socket
  _.extend socket, extras

  window.brahma.socketClose = -> socket.close()
  window.brahma.socketOpen = ->
    ###coffeelint-variable-scope-ignore###
    socket = _.extend connect(), extras

  # Return wrapper
  socketWrapper
