EntityStores = require '../stores/EntityStores'

module.exports =
  getUrl:
    session: (sessionId) ->
      session = EntityStores.Session.get sessionId
      if session
        url = '/session/' + session.id
        if session.state in ['REQUESTED', 'UNDERWAY']
          st = EntityStores.ServiceType.get session.serviceType
          if st?.mode is 'VIDEO'
            url += '/video'
          else
            url += '/chat'
        return url
      else
        return null
