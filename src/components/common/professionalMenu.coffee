React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

{ div, ul, li, span, a } = React.DOM
UserBrief = React.createFactory require '../user/userBrief'
SessionTypeTab = React.createFactory require '../session/sessionTypeTab'

ListStores = require '../../stores/ListStores'
EntityStores = require '../../stores/EntityStores'

UserActions = require '../../actions/UserActions'
SessionActions = require '../../actions/SessionActions'


module.exports = React.createClass

  displayName: 'professionalMenu'

  mixins: [ReactIntl]

  contextTypes:
    user: React.PropTypes.object

  getInitialState: -> @updateSession()

  componentWillMount: ->
    SessionActions.getByServiceType()

  componentDidMount: ->
    EntityStores.Session.addChangeListener @updateSession
    EntityStores.ServiceType.addChangeListener @updateSession
    ListStores.ServiceTypes.addChangeListener @updateSession
    ListStores.SessionsByServiceType.addChangeListener @updateSession

  componentWillUnmount: ->
    EntityStores.Session.removeChangeListener @updateSession
    EntityStores.ServiceType.removeChangeListener @updateSession
    ListStores.ServiceTypes.removeChangeListener @updateSession
    ListStores.SessionsByServiceType.removeChangeListener @updateSession

  handleDocumentClick: (e) ->
    @setState userMenuExpanded: false
    e.nativeEvent.stopImmediatePropagation()

  handleUserMenuClick: (e) ->
    @setState userMenuExpanded: true
    e.nativeEvent.stopImmediatePropagation()

  handleLogout: ->
    UserActions.logout()
    @handleDocumentClick()

  handleCloseMenu: ->
    @handleDocumentClick()

  updateSession: ->
    newState =
      servicetypes: ListStores.ServiceTypes.getObjects()
      sessionsByServiceType: {}
    for st in newState.servicetypes
      newState.sessionsByServiceType[st.id] = ListStores.SessionsByServiceType.getObjects st.id
    @setState newState
    newState

  render: ->
    _this = @
    umClasses = 'userMenu'
    if @state.userMenuExpanded
      umClasses += ' is-expanded'

    console.log "SESSTYPES ", @state

    div id: 'menu',
      div className: 'top-area',
        a href: '/',
          div className: 'logo'
        div className: umClasses, onClick: @handleUserMenuClick,
          div className: 'userMenu-wrapper', onClick: @handleCloseMenu
          span className: 'icon icon-right'
          ul className: 'userMenu-content',
            li {},
              a href: 'profile', @getIntlMessage 'edit-profile'
            li {},
              a
                className: 'logout'
                onClick: @handleLogout
                @getIntlMessage('logout')

        if @context.user
          UserBrief user: @context.user
        div className: 'top-area',
          span className: 'indicator on',
            @getIntlMessage('active')
      div className: 'middle-area',
        @state.servicetypes.map (servicetype) ->
          sessions = _this.state.sessionsByServiceType[servicetype.id] || []
          SessionTypeTab key: servicetype.id, sessionType: servicetype, sessions: sessions
      div className: 'bottom-area',
        div className: 'title',
          @getIntlMessage('next-event')
        div className: 'date',
          span className: 'day',
            '03'
          span className: 'month',
            'diciembre'
        div className: 'schedule',
          span className: 'icon icon-clock'
          span className: 'time',
            '12:03'
          span {},
            'Videoconsulta'
        a href: '#' , className: 'button-pro',
          'Ver'