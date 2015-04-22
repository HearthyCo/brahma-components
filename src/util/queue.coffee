Config = require '../util/config'
Backbone = require 'exoskeleton'
AppDispatcher = require '../dispatcher/AppDispatcher'
Socket = require '../util/socket'
maxRetries = 5
isWorking = false
# coffeelint-variable-scope bug
###coffeelint-variable-scope-ignore###
count = maxRetries

successCallback = (queue, messages) ->
  # console.log 'Success. Sent'
  ###coffeelint-variable-scope-ignore###
  isWorking = false

  for message in messages
    queue.sent++
    message.status = 'success'
    AppDispatcher.trigger 'chat:Send:success', messages: [message]

  ###coffeelint-variable-scope-ignore###
  count = maxRetries
  queue.process()

errorCallback = (queue, outbox) ->
  # console.log 'Error', count, '. Unshift queue'
  ###coffeelint-variable-scope-ignore###
  count--
  ###coffeelint-variable-scope-ignore###
  isWorking = false
  queue.unshift outbox
  if count == 0
    console.log 'Paused. Wait for reconnection.'
    queue.pause()
  else
    queue.process()

queue =
  outbox: []
  sent: 0
  started: false
  paused: false
  socket: null
  initSocket: (user) ->
    @socket = Socket user, Config.chat
    @socket.onmessage = (message) ->
      messages = {}
      switch message.type
        when 'granted'
          console.log 'Auth done'
          if message.data
            sortFn = (a, b) -> a.timestamp > b.timestamp
            messages = message.data.messages.sort sortFn
        when 'message'
          console.log 'Message received', message
          messages = [message]
        when 'attachment'
          console.log 'Attachment received', message
          messages = [message]
        when 'pong'
          console.log 'Message received', message
        when 'status'
          console.warn 'Warn', message
      AppDispatcher.trigger 'chat:Received:success', messages: messages
  push: (payload) ->
    # console.log '> Push to queue', payload
    # When a new message is pushed, count of error is restarted;
    count = maxRetries
    @started = true if not @started
    messages = payload.messages
    for message in messages
      @outbox.push message
    if @paused
      @resume()
    else
      @process()
  unshift: (messages) ->
    messages.push message for message in @outbox
    @outbox = messages
  process: ->
    if not @paused and not isWorking and @length()
      ###coffeelint-variable-scope-ignore###
      isWorking = true
      messages = @outbox
      @outbox = []
      # console.log 'Process:'
      # console.log '-', message for message in messages
      @socket.send messages, (err) ->
        if not err
          successCallback queue, messages
        else
          errorCallback queue, messages
  length: -> @outbox.length
  messagesSent: -> @sent
  pause: -> @paused = true
  resume: ->
    return if not @paused
    @paused = false
    @process()

module.exports = queue