Backbone = require 'exoskeleton'
_ = require 'underscore'
AppDispatcher = require '../dispatcher/AppDispatcher'

# Threshold after which the spinner will be shown, in ms.
delay = 300

# Events we're currently waiting for, in the order they were dispatched.
# Each entry is an object containing the event name and the dispatch time.
# Ex: [ {event:"user:getMe", date: new Date()}, ... ]
###coffeelint-variable-scope-ignore###
waitingFor = []

# Timer used for the delay, when we have one running
###coffeelint-variable-scope-ignore###
timer = null

# Current state
###coffeelint-variable-scope-ignore###
showSpinner = false

# Standard store events
SpinnerStore = {}
_.extend SpinnerStore, Backbone.Events

SpinnerStore.addChangeListener = (callback) ->
  SpinnerStore.on 'change', callback

SpinnerStore.removeChangeListener = (callback) ->
  SpinnerStore.off 'change', callback

# Getter for current value
SpinnerStore.showSpinner = ->
  showSpinner

# Callback for the timer
timerTick = ->
  ###coffeelint-variable-scope-ignore###
  newValue = false
  now = new Date().getTime()
  ###coffeelint-variable-scope-ignore###
  nextWait = 0

  waitingFor.map (entry) ->
    waitedFor = now - entry.date.getTime()
    if waitedFor >= delay
      newValue = true
    else if waitedFor > nextWait
      nextWait = delay - waitedFor

  willTrigger = showSpinner isnt newValue
  showSpinner = newValue
  SpinnerStore.trigger 'change' if willTrigger

  if nextWait > 0
    timer = window.setTimeout timerTick, nextWait

# Event subscription
AppDispatcher.on 'all', (eventName) ->
  tokens = eventName.split ':'
  name = tokens[0] + ':' + tokens[1]

  if tokens[2] is 'request'
    # Add it to the queue
    entry =
      event: name
      date: new Date
    waitingFor.push entry
    # If no timer, set one
    if timer is null
      timer = window.setTimeout timerTick, delay

  else if tokens[2] in ['error', 'success', 'warn']
    # Remove from queue
    waitingFor = _.filter waitingFor, (entry) -> entry.event isnt name
    # Simulate a timer tick to update status, and clear actual timer
    if timer isnt null
      window.clearTimeout timer
      timer = null
    timerTick()

window.brahma.stores.spinner = module.exports = SpinnerStore