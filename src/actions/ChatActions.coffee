Backbone = require 'exoskeleton'
AppDispatcher = require '../dispatcher/AppDispatcher'
Utils = require '../util/actionsUtils'

ChatActions =

  send: (session, msg, user) ->
    # TODO: This is fake, but the success event should be the same.
    # Utils.mkApiPoster '/session/' + session + '/send', msg, 'chat:', 'Send'
    date = new Date()
    AppDispatcher.trigger 'chat:successSend',
      session: session
      messages: [
        id: date.getTime()
        type: 'text'
        timestamp: date
        text: msg
        author: user
      ]

  sendFile: (session, file, user) ->

    date = new Date()
    payload =
      session: session
      messages: [
        id: date.getTime()
        type: 'attachment'
        status: 'pending'
        timestamp: date
        filename: file.name
        filesize: file.size
        author: user
      ]

    AppDispatcher.trigger 'chat:requestSendFile', payload

    fd = new FormData()
    fd.append 'upload', file

    url = window.apiServer + '/session/' + session + '/attach'
    Backbone.ajax
      dataType: 'jsonp'
      url: url
      contentType: false
      processData: false
      type: 'POST'
      data: fd
      error: (xhr, status) ->
        console.error 'API POST Error:', url, status, xhr
        payload.messages[0].status = 'error'
        AppDispatcher.trigger 'chat:errorSendFile', payload
      success: (response) ->
        console.log 'API POST Success:', url, response
        payload.messages[0].status = 'success'
        AppDispatcher.trigger 'chat:successSendFile', payload


module.exports = ChatActions