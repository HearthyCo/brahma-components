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

module.exports =

  ###
    This function buid a breadcrumb for allergies routes (allergies an allergy)
    @param  {string}    key   Name of key for get value in args
    @return {function}        Function which is called with args
  ###
  allergies: -> ->
    crumbs = -> ->
      arr = []
      arr.push
        label: @getIntlMessage('allergies')
        link: urlBuilder('allergies')
        className: 'clock'
      arr

    stores: [ ], list: crumbs()

  ###
    This function buid a breadcrumb for allergies routes (allergies an allergy)
    @param  {string}    key   Name of key for get value in args
    @return {function}        Function which is called with args
  ###
  allergy: -> (args) ->
    store = require '../stores/AllergyStore'

    crumbs = (store, id) -> ->
      arr = []
      allergy = store.get id

      title = if allergy? then allergy.title else @getIntlMessage 'allergy'

      arr.push
        label: @getIntlMessage('allergies')
        link: urlBuilder('allergies')
        className: 'clock'
      arr.push
        label: title
        link: urlBuilder('allergies', id)
        className: 'clock'
      arr

    stores: [ store ], list: crumbs store, args['id']

  ###
    This function buid a breadcrumb for sessions routes (sessions an session)
    @param  {string}    key   Name of key for get value in args
    @return {function}        Function which is called with args
  ###
  sessions: -> (args) ->
    crumbs = (state) -> ->
      arr = []
      arr.push
        label: @getIntlMessage('sessions')
        link: urlBuilder('sessions', state)
        className: 'clock'
      arr

    stores: [ ], list: crumbs args['state']

  ###
    This function buid a breadcrumb for sessions routes (sessions an session)
    @param  {string}    key   Name of key for get value in args
    @return {function}        Function which is called with args
  ###
  session: -> (args) ->
    # Default assign state for key = "state", if key equals "id" get state
    # of session returned from store and set state with session state
    store = require '../stores/SessionStore'

    crumbs = (store, id) -> ->
      arr = []
      session = store.get id

      if session?
        title = session.title
        state = session.state.toLowerCase()
      else
        title = @getIntlMessage 'session'
        # If store gets null,
        # return programmed session while not have route for all sessions
        state = "programmed"

      # Put session node first in array once we have a session state
      arr.push
        label: @getIntlMessage('sessions')
        link: urlBuilder('sessions', state)
        className: 'clock'
      arr.push
        label: title
        link: urlBuilder('sessions', id)
        className: 'clock'
      arr

    stores: [ store ], list: crumbs store, args['id']

  ###
    This function buid a breadcrumb for top-up routes
    @param  {string}    key   Name of key for get value in args
    @return {function}        Function which is called with args
  ###
  topup: -> ->
    crumbs = -> ->
      arr = []

      arr.push
        label: crumbBuilder @getIntlMessage('top-up')
        link: urlBuilder('top-up')
        className: 'clock'
      arr

    stores: [ ], list: crumbs()

  ###
    This function buid a breadcrumb for payment routes
    @param  {string}    key   Name of key for get value in args
    @return {function}        Function which is called with args
  ###
  payments: -> ->
    crumbs = -> ->
      arr = []

      arr.push
        label: @getIntlMessage('top-up')
        link: urlBuilder('top-up')
        className: 'clock'
      arr.push
        label: @getIntlMessage('payment-history')
        link: urlBuilder('top-up', 'payments')
        className: 'clock'
      arr

    stores: [ ], list: crumbs()