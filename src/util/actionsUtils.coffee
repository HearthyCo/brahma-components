Config = require '../util/config'
Backbone = require 'exoskeleton'
AppDispatcher = require '../dispatcher/AppDispatcher'
_ = require 'underscore'


mkApiCaller = (endpoint, evtModel, evtAction, opts) ->
  new window.Promise (resolve, reject) ->
    url = Config.api.url + endpoint
    opts = opts or {}
    method = opts.type or 'GET'

    opts = _.defaults opts,
      url: url
      errorLevel: 'error' # error, warn, debug

    callbacks =
      success: (response) ->
        # When status is 0 and protocol is file, we wrongfully get a success
        # with no response. As we always return something not-null, if we get
        # such a response, we call the error callback instead.
        return callbacks.error(null, 0) if not response
        console.log "API #{method} Success:",
          [evtModel, evtAction], url, response
        AppDispatcher.trigger [evtModel,evtAction,'success'].join(':'), response
        opts.success response if opts.success
        resolve response
      error: (xhr, status) ->
        console.error "API #{method} Error:", [evtModel, evtAction], url,
          status, xhr, opts
        AppDispatcher.trigger [
          evtModel
          evtAction
          opts.errorLevel
        ].join(':'), opts
        opts.error xhr, status if opts.error
        reject status

    AppDispatcher.trigger [evtModel,evtAction,'request'].join(':'),
      opts.payload or {}
    r = Backbone.ajax _.extend {}, opts, callbacks
    # Prevent "Uncaught (in promise)"
    r.then(
      ->
      ->
    )

callbackRenamer = (opts) ->
  if opts
    if opts.success
      opts.afterSuccess = opts.success
      delete opts.success
    if opts.error
      opts.afterError = opts.error
      delete opts.error
    opts


module.exports =

  mkApiGetter: (endpoint, evtModel, evtAction, opts) ->
    mkApiCaller endpoint, evtModel, evtAction, opts

  mkApiPoster: (endpoint, payload, evtModel, evtAction, opts) ->
    opts = _.defaults {}, opts or {},
      contentType: "application/json; charset=utf-8"
      type: 'POST'
      data: JSON.stringify payload
    mkApiCaller endpoint, evtModel, evtAction, opts