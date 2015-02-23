Backbone = require 'exoskeleton'
AppDispatcher = require '../dispatcher/AppDispatcher'
_ = require 'underscore'

module.exports = Utils =

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
          _list = ret.map (v) ->
            if v instanceof Object then v.id else v
          Store.trigger 'change'

    Store

  # Creates a new Sub-List Store of the specified entity type
  mkSubListStore: (baseEntityStore, bindings) ->

    # Private storage
    _lists = {}

    # Public interface
    Store = _.extend {}, Backbone.Events,

      getIds: (id) ->
        return _lists[id]

      getObjects: (id) ->
        return _lists[id]?.map baseEntityStore.get

      # Standard events for views
      addChangeListener: (cb) -> @on 'change', cb
      removeChangeListener: (cb) -> @off 'change', cb

      # You can add anything else later.

    # Subscriptions
    AppDispatcher.on 'all', (eventName, payload) ->
      # We don't know how to handle this, so the user
      # has to specify the bindings himself.
      if bindings[eventName]
        ret = bindings[eventName].call Store, payload, _lists
        changed = false
        if ret instanceof Object
          for owner, list of ret
            _lists[owner] = list.map (v) ->
              if v instanceof Object then v.id else v
            changed = true
        Store.trigger 'change' if changed

    Store

  treeEval: (tree, fname, args, ignoreLayer) ->
    return undefined if not tree
    return undefined if typeof tree is 'function'
    ignoreLayer = true if ignoreLayer is undefined
    if not ignoreLayer and tree[fname]
      return tree[fname].apply tree, args, false
    ret = {}
    for k,v of tree
      val = Utils.treeEval v, fname, args, false
      ret[k] = val if val isnt undefined
    ret
