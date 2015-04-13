EntityStores = require '../stores/EntityStores'

module.exports =
  getUrl:
    session: (session) ->
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
