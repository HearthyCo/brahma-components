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
    This function buid a breadcrumb for histories routes
    @param  {string}    key   Name of key for get value in args
    @return {function}        Function which is called with args
  ###
  histories: -> ->
    crumbs = -> ->
      arr = []
      arr.push
        label: @getIntlMessage 'histories'
        link: urlBuilder 'histories'
        className: 'history'
      arr

    stores: [ ], list: crumbs()

  ###
    This function buid a breadcrumb for allergies routes (allergies an allergy)
    @param  {string}    key   Name of key for get value in args
    @return {function}        Function which is called with args
  ###
  history: -> (args) ->
    store = (require '../stores/EntityStores').HistoryEntry

    crumbs = (store, id) -> ->
      arr = []
      history = store.get id

      title = if history? then history.title else @getIntlMessage 'history'

      arr.push
        label: @getIntlMessage 'histories'
        link: urlBuilder 'histories'
        className: 'history'
      arr.push
        label: title
        link: urlBuilder 'histories', id
        className: 'history'
      arr

    stores: [ store ], list: crumbs store, args['id']

  ###
    This function buid a breadcrumb for allergies routes (allergies an allergy)
    @param  {string}    key   Name of key for get value in args
    @return {function}        Function which is called with args
  ###
  allergies: -> ->
    crumbs = -> ->
      arr = []
      arr.push
        label: @getIntlMessage 'allergies'
        link: urlBuilder 'allergies'
        className: 'history'
      arr

    stores: [ ], list: crumbs()

  ###
    This function buid a breadcrumb for allergies routes (allergies an allergy)
    @param  {string}    key   Name of key for get value in args
    @return {function}        Function which is called with args
  ###
  allergy: -> (args) ->
    store = (require '../stores/EntityStores').HistoryEntry

    crumbs = (store, id) -> ->
      arr = []
      allergy = store.get id

      title = if allergy? then allergy.title else @getIntlMessage 'allergy'

      arr.push
        label: @getIntlMessage 'allergies'
        link: urlBuilder 'allergies'
        className: 'history'
      arr.push
        label: title
        link: urlBuilder 'allergies', id
        className: 'history'
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
      # link = urlBuilder('sessions', state) if state?
      link = urlBuilder('sessions') if not state?

      arr.push
        label: @getIntlMessage 'sessions'
        link: link
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
    store = (require '../stores/EntityStores').Session

    crumbs = (store, id) -> ->
      arr = []
      session = store.get id

      sessionStates = {
        programmed: "programmed"
        underway: "underway"
        requested: "underway"
        closed: "closed"
        finished: "closed"
      }

      if session?
        title = session.title
        if session.state?
          state = sessionStates[session.state.toLowerCase()]
        else
          state = "programmed"
      else
        title = @getIntlMessage 'session'
        # If store gets null,
        # return programmed session while not have route for all sessions
        state = "programmed"

      # Put session node first in array once we have a session state
      arr.push
        label: @getIntlMessage 'sessions'
        # link: urlBuilder 'sessions', state
        link: urlBuilder 'sessions'
        className: 'clock'
      arr.push
        label: title
        link: urlBuilder 'session', id
        className: 'clock'
      arr

    stores: [ store ], list: crumbs store, args['sessionId']

  ###
    This function buid a breadcrumb for top-up routes
    @param  {string}    key   Name of key for get value in args
    @return {function}        Function which is called with args
  ###
  topup: -> ->
    crumbs = -> ->
      arr = []

      arr.push
        label: crumbBuilder @getIntlMessage 'top-up'
        link: urlBuilder 'top-up'
        className: 'pig'
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
        label: @getIntlMessage 'top-up'
        link: urlBuilder 'top-up'
        className: 'pig'
      arr.push
        label: @getIntlMessage 'payment-history'
        link: urlBuilder 'top-up', 'payments'
        className: 'pig'
      arr

    stores: [ ], list: crumbs()

  ###
    This function buid a breadcrumb for histories routes
    @param  {string}    key   Name of key for get value in args
    @return {function}        Function which is called with args
  ###
  tasks: -> ->
    crumbs = -> ->
      arr = []
      arr.push
        label: @getIntlMessage 'treatments'
        link: urlBuilder 'tasks'
        className: 'pill'
      arr

    stores: [ ], list: crumbs()