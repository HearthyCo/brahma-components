Config = require '../util/config'
Backbone = require 'exoskeleton'
AppDispatcher = require '../dispatcher/AppDispatcher'
Socket = require '../util/socket'

SessionActions = require '../actions/SessionActions'

maxRetries = 5
isWorking = false
# coffeelint-variable-scope bug
###coffeelint-variable-scope-ignore###
count = maxRetries

successCallback = (queue, messages) ->
  # console.log '> Success. Sent'
  ###coffeelint-variable-scope-ignore###
  isWorking = false

  # msgs = []
  # for message in messages
  #   msgs.push message.data.message

  # console.log "> Success for #{messages.length}", msgs

  for message in messages
    queue.sent++
    message.status = 'success'
    AppDispatcher.trigger 'chat:Send:success', messages: [message]

  ###coffeelint-variable-scope-ignore###
  count = maxRetries
  queue.process()

errorCallback = (queue, messages) ->
  ###coffeelint-variable-scope-ignore###
  count--
  ###coffeelint-variable-scope-ignore###
  isWorking = false

  # console.log "> Error for #{messages.length}. Tries left: #{count}"

  queue.unshift messages
  if count == 0
    # console.log "> Paused with #{messages.length}. Wait for connection"
    queue.pause()
  else
    queue.process()

# Check if two arrays contains the same elements, with shallow compare.
arrayEquals = (a, b) ->
  return false if a?.length isnt b?.length
  for i in [0..a.length - 1]
    return false if a[i] isnt b[i]
  true

# Call a function that returns a promise after a brief delay. If the promise
# result doesn't pass a check, retry only once after a longer delay.
promiseCheckOrRetry = (f, check) ->
  cb = ->
    promise = f()
    promise.then (val) ->
      if not check(val)
        window.setTimeout f, 500
  window.setTimeout cb, 50

queue =
  # We store here all the outcoming messages
  outbox: []

  sent: 0
  started: false
  paused: false
  socket: null
  initSocket: (user) ->
    @socket?.close()
    @socket = Socket user, Config.chat
    @socket.onmessage = (message) ->
      messages = {}
      switch message.type
        when 'joined'
          # console.log '> Joined', message
          if message.data
            AppDispatcher.trigger 'chat:Received:success',
              messages: message.data.messages
        when 'message', 'attachment'
          AppDispatcher.trigger 'chat:Received:success', messages: [message]
        when 'update'
          # We send only the update data through the dispatcher
          # so the stores can pick it up using standard path conventions
          # console.log '> Async update:', message.data
          AppDispatcher.trigger 'update:Received:success', message.data
        when 'reload'
          # Call a refresh/reload action on the specified entity
          switch message.data.type
            when 'session'
              promiseCheckOrRetry(
                () -> SessionActions.refresh message.data.target
                (pl) ->
                  got = pl.users?.map (e) -> e.id
                  expected = message.data.participants
                  arrayEquals got, expected
              )
        when 'status'
          console.warn 'Warn', message
      AppDispatcher.trigger 'chat:Received:success', messages: messages
    @socket.onauth = -> queue.resume()

  close: ->
    @socket?.close()

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

  # Adds messages on queue to the unsent messages
  unshift: (messages) ->
    # Keep potential a new queue
    messages.push message for message in @outbox
    @outbox = messages
    # console.log "Failed delivery. Queue with #{@outbox.length} message(s)"

  process: ->

    # msgs = []
    # for message in @outbox
    #   msgs.push message.data.message

    # console.log "Called process with #{@outbox.length} message(s) on queue:",
      # msgs

    if not @paused and not isWorking and @outbox.length
      ###coffeelint-variable-scope-ignore###
      isWorking = true

      # We're working on these messages
      messages = @outbox
      @outbox = []

      # console.log "> Processing #{messages.length} queued", msgs
      if @socket.isReady()
        @socket.send messages, (err) ->
          if err
            errorCallback queue, messages
          else
            successCallback queue, messages
      else
        errorCallback queue, messages

  length: -> @outbox.length
  messagesSent: -> @sent
  pause: ->
    # console.log "> Queue paused"
    @paused = true
  resume: ->
    # console.log "> Queue resumed"
    @paused = false
    @process()

module.exports = queue