AppDispatcher = require '../dispatcher/AppDispatcher'
EntityStores = require '../stores/EntityStores'

module.exports =
  getUrl:
    session: (session) ->
      if 'object' isnt typeof session
        session = EntityStores.Session.get session

      if session
        url = '/session/' + session.id
        if session.state in ['REQUESTED', 'UNDERWAY']
          st = EntityStores.ServiceType.get session.serviceType
          if st?.mode is 'VIDEO' and process.env.HEARTHY_APP is 'web'
            url += '/video'
          else
            url += '/chat'
        return url
      else
        return null
