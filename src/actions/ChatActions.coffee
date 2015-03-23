Config = require '../util/config'
Backbone = require 'exoskeleton'
AppDispatcher = require '../dispatcher/AppDispatcher'
Utils = require '../util/actionsUtils'
SocketUtils = require '../util/socketUtils'
FrontendUtils = require '../util/frontendUtils'
Queue = require '../util/queue'

ChatActions =
  send: (session, msg, user) ->
    # TODO: This is fake, but the success event should be the same.
    # Utils.mkApiPoster '/session/' + session + '/send', msg, 'chat:', 'Send'

    id = SocketUtils.mkMessageId user.id, session
    payload =
      messages: [
        id: id
        type: 'message'
        session: session
        author: user.id
        data:
          message: msg
        timestamp: new Date().getTime()
      ]

    AppDispatcher.trigger 'chat:requestSend', payload
    Queue.push payload

  sendFile: (session, file, user) ->
    id = SocketUtils.mkMessageId user.id, session
    payload =
      messages: [
        id: id
        type: 'attachment'
        session: session
        author: user.id
        data:
          message: file.name
          size: file.size
        status: 'pending'
        timestamp: new Date().getTime()
      ]

    AppDispatcher.trigger 'chat:requestSendFile', payload

    fd = new FormData()
    url = Config.api.url + '/session/' + session + '/attach'
    opts =
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
        setTimeout retry, 5000
      success: (response) ->
        console.log 'API POST Success:', url, response
        payload.messages[0].status = 'success'
        payload.messages[0].data.type = response.attachments[0].mime
        payload.messages[0].data.href = response.attachments[0].url
        payload.messages[0].data.hasThumb = response.attachments[0].hasThumb
        AppDispatcher.trigger 'chat:successSendFile', payload

    retries = 4
    retry = ->
      if retries-- > 0
        payload.messages[0].status = 'pending'
        AppDispatcher.trigger 'chat:requestSendFile', payload
        Backbone.ajax opts

    if file.type.startsWith 'image/'
      FrontendUtils.imageScaleBlob file, 1920, 1920, (blob) ->
        fd.append 'upload', blob, file.name
        FrontendUtils.imageScaleBlob blob, 125, 125, (thumbblob) ->
          if thumbblob isnt blob
            fd.append 'upload_thumb', thumbblob, file.name
          Backbone.ajax opts
    else
      fd.append 'upload', file
      Backbone.ajax opts


module.exports = ChatActions