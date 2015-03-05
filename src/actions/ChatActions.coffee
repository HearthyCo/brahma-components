Backbone = require 'exoskeleton'
AppDispatcher = require '../dispatcher/AppDispatcher'
Utils = require '../util/actionsUtils'
Queue = require '../util/queue'

msgId = (user, session) ->
  date = new Date().getTime()
  '' + session + user.id + date + Queue.messagesSent()

ChatActions =
  send: (session, msg, user) ->
    # TODO: This is fake, but the success event should be the same.
    # Utils.mkApiPoster '/session/' + session + '/send', msg, 'chat:', 'Send'

    payload =
      session: session
      messages: [
        type: 'message'
        timestamp: new Date().getTime()
        text: msg
        author: user
      ]

    AppDispatcher.trigger 'chat:requestSend', payload
    Queue.push payload

  sendFile: (session, file, user) ->
    id = msgId user, session
    payload =
      session: session
      messages: [
        id: id
        type: 'attachment'
        status: 'pending'
        timestamp: new Date().getTime()
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
        payload.messages[0].fileurl = response.attachments[0].url

        AppDispatcher.trigger 'chat:successSendFile', payload


module.exports = ChatActions