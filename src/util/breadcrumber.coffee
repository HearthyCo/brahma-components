
urlBuilder = (args...) ->
  url = ""
  url = "/" unless args
  url += "/" + arg for arg in args
  url

crumbBuilder = (label, link, cls) ->
  { label: label, link: link, className: cls }

breadcrumBuilder = (object) ->
  object.list.unshift crumbBuilder 'Home', urlBuilder(), 'home'
  object

module.exports = {

  alergies: (key) -> (args) ->
    store = require '../stores/AllergyStore'
    crumbs = []

    crumbs.push crumbBuilder @getIntlMessage('allergies'), urlBuilder('allergies'), 'clock'

    if key? && args?
      alergy = store.get args[key]

      title = if alergy? then alergy.title else @getIntlMessage.call context: @state, 'alergy'

      crumbs.push crumbBuilder title, urlBuilder('allergy', args[key]), 'clock'

    breadcrumBuilder { stores: [ store ], list: crumbs }

  sessions: (key) -> (args) ->
    store = require '../stores/SessionsStore'
    crumbs = []

    session = { state: args[key] }
    if key == "id"
      store = require '../stores/SessionStore'
      session = store.get args[key]

      title = if session? then session.title else @getIntlMessage 'session'
      crumbs.push crumbBuilder session.title, urlBuilder('sessions', args[key]), 'clock'

    crumbs.unshift crumbBuilder @getIntlMessage('sessions'), urlBuilder('sessions', session.state), 'clock'

    breadcrumBuilder { stores: [ store ], list: crumbs }
}