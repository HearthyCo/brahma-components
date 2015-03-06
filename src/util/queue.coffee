Backbone = require 'exoskeleton'
AppDispatcher = require '../dispatcher/AppDispatcher'
Socket = require '../util/socket'
RETRY_NUMBER = 5
isWorking = false
count = RETRY_NUMBER

successCallback = (queue, outbox) ->
  console.log 'Success. Sent'
  isWorking = false

  for queuedMessage in outbox
    messages = queuedMessage.messages
    for message in messages
      queue.sent++
      message.status = 'success'
      AppDispatcher.trigger 'chat:successSend', message

  count = RETRY_NUMBER
  queue.process()

errorCallback = (queue, outbox) ->
  console.log 'Error', count, '. Unshift queue'
  count--
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
    @socket = Socket user, window.chatServer
    @socket.onmessage = (o) ->
      console.log 'O', o
      AppDispatcher.trigger 'chat:successReceived', messages: [o]
  push: (message) ->
    console.log '> Push to queue', message
    # When a new message is pushed, count of error is restarted;
    count = RETRY_NUMBER
    @started = true if not @started

    isQueued = false
    for queuedMessage in @outbox
      if message.session is queuedMessage.session
        isQueued = true
        messages = message.messages
        for message in messages
          queuedMessage.messages.push

    @outbox.push message if !isQueued
    if @paused
      @resume()
    else
      @process()
  unshift: (messages) ->
    messages.push msg for msg in @outbox
    @outbox = messages
  process: ->
    if not @paused and not isWorking and @length()
      isWorking = true
      messages = @outbox
      @outbox = []
      console.log 'Process:'
      console.log '-', message for message in messages
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