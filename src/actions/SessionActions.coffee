AppDispatcher = require '../dispatcher/AppDispatcher'
Backbone = require 'exoskeleton'

SessionActions =

  create: (service, state, startDate) ->
    console.log "ARGS ", service, state, startDate
    Backbone.ajax
      url: window.apiServer + '/session'
      contentType: "application/json; charset=utf-8"
      type: 'POST'
      dataType: 'jsonp'
      data: JSON.stringify service: service, state: state, startDate: startDate
      success: (result) ->
        console.log "RESUL", result
        AppDispatcher.trigger 'session:create', result
      error: (xhr, status) ->
        console.error 'Can\t create session', status, xhr

  refresh: (target) ->
    AppDispatcher.trigger 'session:refresh',
      id: target

module.exports = SessionActions