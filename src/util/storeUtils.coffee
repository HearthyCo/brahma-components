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

  # Equivalent to map for object trees.
  # Arguments:
  #   tree: the structure to iterate on.
  #   fname: the function name to call on each leaf, if present.
  #   args: array of arguments to pass to the function.
  #   ignoreLayer: used internally to skip the first layer of a tree.
  #       Useful when doing something like:
  #         x.demo = (x) -> treeEval x, 'demo', [x]
  #       So it doesn't get stuck on a recursive loop.
  # Caveats:
  #   fname will be called binded to the object containing it
  #   recursion stops at any object containing fname, even if it's not a leaf
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

  # Helper for bindings which need to append to a sublist store.
  # Just put it as a middleware in front of a regular binding, and instead
  # of overwritting, it will append to the already present values.
  subListAppender: (func) -> (o, l) ->
    ret = func o, l
    for k, v of ret
      if l[k]
        ret[k] = l[k].concat v
    return ret
