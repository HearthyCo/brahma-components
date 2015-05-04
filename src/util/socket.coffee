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
    new window.WebSocket url, ["protocolOne", "protocolTwo"]

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
  checkSend = (callback, t) ->
    if socket.readyState isnt window.WebSocket.OPEN
      # Socket not ready
      # console.log "check: Socket not ready",
      #   "Ready: #{socket.readyState}", "Buffer: #{socket.bufferedAmount}",
      #   "Protocol: #{socket.protocol}", "Check timer: #{t}"
      callback true if callback # call err
    else if socket.bufferedAmount is 0
      # Buffer empty, message sent
      # console.log "check: Buffer empty",
      #   "Ready: #{socket.readyState}", "Buffer: #{socket.bufferedAmount}",
      #   "Protocol: #{socket.protocol}", "Check timer: #{t}"
      callback false if callback # call success (!err)
    else
      # Socket ready and buffer has something, keep waiting
      # console.log "check: Buffer has something",
      #   "Ready: #{socket.readyState}", "Buffer: #{socket.bufferedAmount}",
      #   "Protocol: #{socket.protocol}", "Check timer: #{t}"
      return true

    # Done, stop waiting
    window.clearInterval t if t

    # Callback called
    return false

  # Default callbacks
  socketWrapper =
    onmessage: (json) -> console.log "> onMessage", json
    onerror: (error) -> console.log "> onError", error
    onclose: (code) -> console.log "> onClose", code
    onopen: -> console.log "> onOpen"
    onauth: -> console.log "> onAuth"
    onping: -> console.log "> onPing"

    ping: ->
      id = SocketUtils.mkMessageId user.id
      ping = id: id, type: 'ping', data: message: 'Ping'
      socket.send JSON.stringify ping
      if checkSend()
        interval = window.setInterval (->
          checkSend(socketWrapper.onping, interval)
        ), 100

    send: (messages, callback) ->
      socket.send JSON.stringify messages
      if checkSend()
        interval = window.setInterval (-> checkSend(callback, interval)), 100
      # console.log 'Sending', messages, "Ready: #{socket.readyState}",
      #   "Buffer: #{socket.bufferedAmount}", "Protocol: #{socket.protocol}"
      #   "Check timer: #{interval}"

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
          checkSend(socketWrapper.onAuth, interval)
        ), 100
    onclose: (code) ->
      socketWrapper.onclose code if socketWrapper.onclose
      reconnect()
    onerror: (error) ->
      socketWrapper.onerror error if socketWrapper.onerror
    onmessage: (message) ->
      console.log "> Message received"
      try
        data = JSON.parse message.data
      catch ex
        console.log '> This doesn\'t look like a valid JSON: ',
          message.data, ex

      socketWrapper.onmessage data if socketWrapper.onmessage

  # Extend socket
  _.extend socket, extras

  # Return wrapper
  socketWrapper