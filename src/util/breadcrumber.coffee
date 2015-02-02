###
  This functions creates an url from object list
  @param  {object} args   List of url nodes
  @return {string} object String wit nodes join "/"
###
urlBuilder = (args...) ->
  url = ""
  url = "/" unless args
  url += "/" + arg for arg in args
  url

###
  This functions creates an crumb object
  @param  {string} label  Crumb label
  @param  {string} link   Crumb link
  @param  {string} cls    Crumb class
  @return {object} object Object with crumb variables
###
crumbBuilder = (label, link, cls) ->
  { label: label, link: link, className: cls }

###
  This functions appends on first position Home node of breadcrumb
  @param  {object} object Object with stores and list
  @return {object} object Object modified with home in first position
###
breadcrumBuilder = (object) ->
  object.list.unshift crumbBuilder 'home', urlBuilder(), 'home'
  object

module.exports = {
  ###
    This function buid a breadcrumb for alergies routes (alergies an allergy)
    @param  {string}    key   Name of key for get value in args
    @return {function}        Function which is called with args
  ###
  alergies: (key) -> (args) ->
    store = require '../stores/AllergyStore'
    crumbs = []

    crumbs.push crumbBuilder @getIntlMessage('allergies'),
      urlBuilder('allergies'), 'clock'

    if key? && args?
      alergy = store.get args[key]

      title = if alergy? then alergy.title else @getIntlMessage 'allergy'

      crumbs.push crumbBuilder title, urlBuilder('allergy', args[key]), 'clock'

    breadcrumBuilder { stores: [ store ], list: crumbs }

  ###
    This function buid a breadcrumb for sessions routes (sessions an session)
    @param  {string}    key   Name of key for get value in args
    @return {function}        Function which is called with args
  ###
  sessions: (key) -> (args) ->
    store = require '../stores/SessionsStore'
    crumbs = []

    # Default assign state for key = "state", if key equals "id" get state
    # of session returned from store and set state with session state
    state = args[key]
    if key == "id"
      store = require '../stores/SessionStore'
      session = store.get args[key]

      if session?
        title = session.title
        state = session.state
      else
        title = @getIntlMessage 'session'
        # If store gets null,
        # return programmed session while not have route for all sessions
        state = "programmed"

      crumbs.push crumbBuilder title, urlBuilder('sessions', args[key]), 'clock'

    # Put session node first in array once we have a session state
    crumbs.unshift crumbBuilder @getIntlMessage('sessions'),
      urlBuilder('sessions', state), 'clock'

    breadcrumBuilder { stores: [ store ], list: crumbs }

  ###
    This function buid a breadcrumb for top-up routes
    @param  {string}    key   Name of key for get value in args
    @return {function}        Function which is called with args
  ###
  topup: (key) -> (args) ->
    store = require '../stores/TransactionStore'
    crumbs = []

    crumbs.push crumbBuilder @getIntlMessage('top-up'),
      urlBuilder('top-up'), 'clock'

    if key? && key == "payments"
      crumbs.push crumbBuilder @getIntlMessage('payment-history'),
        urlBuilder('top-up', 'payments'), 'clock'

    breadcrumBuilder { stores: [ store ], list: crumbs }
}