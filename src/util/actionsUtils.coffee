Backbone = require 'exoskeleton'
AppDispatcher = require '../dispatcher/AppDispatcher'
_ = require 'underscore'

module.exports =

  mkApiGetter: (endpoint, evtPrefix, evtSuffix) ->
    AppDispatcher.trigger evtPrefix + 'request' + evtSuffix, {}
    url = window.apiServer + endpoint
    Backbone.ajax
      dataType: 'jsonp'
      url: url
      success: (response) ->
        console.log 'API GET Success:', url, response
        AppDispatcher.trigger evtPrefix + 'success' + evtSuffix, response
      error: (xhr, status) ->
        console.error 'API GET Error:', url, status, xhr
        AppDispatcher.trigger evtPrefix + 'error' + evtSuffix, {}

  mkApiPoster: (endpoint, payload, successEvent, errorEvent) ->
    url = window.apiServer + endpoint
    AppDispatcher.trigger evtPrefix + 'request' + evtSuffix, payload
    Backbone.ajax
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
