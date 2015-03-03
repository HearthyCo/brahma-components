Backbone = require 'exoskeleton'
AppDispatcher = require '../dispatcher/AppDispatcher'

RETRY_NUMBER = 5
isWorking = false
count = RETRY_NUMBER

successCallback = (queue, messages) ->
  # console.log 'Success. Sent:', messages.length, 'messages'
  # console.log '-', message for message in messages
  isWorking = false

  for message in messages
    queue.sent++
    message.messages[0].status = 'success'
    AppDispatcher.trigger 'chat:successSend', message

  count = RETRY_NUMBER
  queue.process()

errorCallback = (queue, messages) ->
  # console.log 'Error', count, '. Unshift queue:', messages.length, 'messages'
  # console.log '-', message for message in messages
  count--
  isWorking = false
  queue.unshift messages
  if count == 0
    # console.log 'Paused. Wait for reconnection.'
    queue.pause()
  else
    queue.process()

queue =
  outbox: []
  sent: 0
  started: false
  paused: false
  push: (message) ->
    # console.log '> Push to queue', message
    # When a new message is pushed, count of error is restarted;
    count = RETRY_NUMBER
    @started = true if not @started
    @outbox.push message
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
      # console.log 'Process:'
      # console.log '-', message for message in messages
      # TODO
      # Fake success.
      success = if Math.random() >= 0.80 then true else false
      if success
        successCallback queue, messages
      else
        errorCallback queue, messages
  length: -> @outbox.length
  messageSent: -> @sent
  pause: -> @paused = true
  resume: ->
    return if not @paused
    @paused = false
    @process()

module.exports = queue