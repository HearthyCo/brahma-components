Backbone = require 'exoskeleton'
AppDispatcher = require '../dispatcher/AppDispatcher'
_ = require 'underscore'

module.exports =

  # Creates a new Entity Store for the given entity name
  mkEntityStore: (entityName, extraHandle) ->

    # Private storage
    _models = {}

    # Public interface
    Store = _.extend {}, Backbone.Events,

      get: (id) ->
        return _models[id]

      # Standard events for views
      addChangeListener: (cb) -> @on 'change', cb
      removeChangeListener: (cb) -> @off 'change', cb

      # You can add anything else later.

    # Subscriptions
    AppDispatcher.on 'all', (eventName, payload) ->
      # We don't really care about the event name.
      # Only check if it contains interesting entities.
      if extraHandle
        extraHandle.call Store, eventName, payload
      if payload[entityName] and payload[entityName] instanceof Array
        for s in payload[entityName]
          _models[s.id] = s
        if payload[entityName].length > 0
          Store.trigger 'change'

    Store

  # Creates a new List Store of the specified entity type
  mkListStore: (baseEntityStore, bindings) ->

    # Private storage
    _list = []

    # Public interface
    Store = _.extend {}, Backbone.Events,

      getIds: ->
        return _list

      getObjects: ->
        return _list.map baseEntityStore.get

      # Standard events for views
      addChangeListener: (cb) -> @on 'change', cb
      removeChangeListener: (cb) -> @off 'change', cb

      # You can add anything else later.

    # Subscriptions
    AppDispatcher.on 'all', (eventName, payload) ->
      # We don't know how to handle this, so the user
      # has to specify the bindings himself.
      if bindings[eventName]
        ret = bindings[eventName].call Store, payload, _list
        if ret instanceof Array
          _list = ret
          Store.trigger 'change'

    Store
