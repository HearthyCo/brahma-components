Config = require '../util/config'
Backbone = require 'exoskeleton'
AppDispatcher = require '../dispatcher/AppDispatcher'
_ = require 'underscore'

module.exports =

  mkApiGetter: (endpoint, evtPrefix, evtSuffix, opts) ->
    url = Config.api.url + endpoint
    AppDispatcher.trigger evtPrefix + 'request' + evtSuffix, {}
    opts = opts || {}
    defaultOpts =
      dataType: 'jsonp'
      url: url
      success: (response) ->
        console.log 'API GET Success:', url, response
        AppDispatcher.trigger evtPrefix + 'success' + evtSuffix, response
      error: (xhr, status) ->
        console.error 'API GET Error:', url, status, xhr
        AppDispatcher.trigger evtPrefix + 'error' + evtSuffix, {}
    defaultOpts.defaultOpts = defaultOpts
    opts = _.extend {}, defaultOpts, opts
    Backbone.ajax opts

  mkApiPoster: (endpoint, payload, evtPrefix, evtSuffix, opts) ->
    url = Config.api.url + endpoint
    AppDispatcher.trigger evtPrefix + 'request' + evtSuffix, payload
    opts = opts || {}
    defaultOpts =
      dataType: 'jsonp'
      url: url
      contentType: "application/json; charset=utf-8"
      type: 'POST'
      data: JSON.stringify payload
      success: (response) ->
        console.log 'API POST Success:', url, response
        AppDispatcher.trigger evtPrefix + 'success' + evtSuffix, response
      error: (xhr, status) ->
        console.error 'API POST Error:', url, status, xhr
        AppDispatcher.trigger evtPrefix + 'error' + evtSuffix, {}
    defaultOpts.defaultOpts = defaultOpts
    opts = _.extend {}, defaultOpts, opts
    Backbone.ajax opts
