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
        timestamp: date
        text: msg
        author: user
      ]

module.exports = ChatActions