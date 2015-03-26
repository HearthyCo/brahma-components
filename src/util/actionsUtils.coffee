Config = require '../util/config'
Backbone = require 'exoskeleton'
AppDispatcher = require '../dispatcher/AppDispatcher'
_ = require 'underscore'


mkApiCaller = (endpoint, evtPrefix, evtSuffix, opts) ->
  url = Config.api.url + endpoint
  opts = opts || {}
  method = opts.type || 'GET'

  opts = _.defaults opts,
    dataType: 'jsonp'
    url: url

  callbacks =
    success: (response) ->
      # When status is 0 and protocol is file, we wrongfully get a success
      # with no response. As we always return something not-null, if we get
      # such a response, we call the error callback instead.
      return callbacks.error(null, 0) if not response
      console.log "API #{method} Success:", url, response
      AppDispatcher.trigger evtPrefix + 'success' + evtSuffix, response
      opts.success response if opts.success
    error: (xhr, status) ->
      console.error "API #{method} Error:", url, status, xhr
      AppDispatcher.trigger evtPrefix + 'error' + evtSuffix, {}
      opts.error xhr, status if opts.error

  AppDispatcher.trigger evtPrefix + 'request' + evtSuffix, opts.payload || {}
  Backbone.ajax _.extend {}, opts, callbacks


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

  mkApiGetter: (endpoint, evtPrefix, evtSuffix, opts) ->
    mkApiCaller endpoint, evtPrefix, evtSuffix, opts

  mkApiPoster: (endpoint, payload, evtPrefix, evtSuffix, opts) ->
    opts = _.extend opts || {},
      contentType: "application/json; charset=utf-8"
      type: 'POST'
      data: JSON.stringify payload
    mkApiCaller endpoint, evtPrefix, evtSuffix, opts