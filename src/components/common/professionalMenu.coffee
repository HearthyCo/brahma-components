React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

{ div, ul, li, span, a } = React.DOM
UserBrief = React.createFactory require '../user/userBrief'
SessionTypeTab = React.createFactory require '../session/sessionTypeTab'
Indicator = React.createFactory require './indicator'

ListStores = require '../../stores/ListStores'
EntityStores = require '../../stores/EntityStores'

UserActions = require '../../actions/UserActions'
SessionActions = require '../../actions/SessionActions'


module.exports = React.createClass

  displayName: 'professionalMenu'

  mixins: [ReactIntl]

  propTypes:
    blocked: React.PropTypes.bool

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
    ListStores.Session.Messages.addChangeListener @updateSession

  componentWillUnmount: ->
    EntityStores.Session.removeChangeListener @updateSession
    EntityStores.ServiceType.removeChangeListener @updateSession
    ListStores.ServiceTypes.removeChangeListener @updateSession
    ListStores.SessionsByServiceType.removeChangeListener @updateSession
    ListStores.Session.Messages.removeChangeListener @updateSession

  handleOpenMenu: ->
    @setState userMenuExpanded: true

  handleCloseMenu: (e) ->
    @setState userMenuExpanded: false
    e.stopPropagation()

  handleLogout: ->
    UserActions.logout()

  updateSession: ->
    newState =
      servicetypes: ListStores.ServiceTypes.getObjects()
      sessionsByServiceType: {}
    for st in newState.servicetypes
      newState.sessionsByServiceType[st.id] =
        ListStores.SessionsByServiceType.getObjects st.id
    @setState newState
    newState

  render: ->
    _this = @
    umClasses = 'userMenu'
    if @state.userMenuExpanded
      umClasses += ' is-expanded'
    else if @state.userMenuExpanded is false
      umClasses += ' is-collapsed'

    div id: 'menu',
      if @props.blocked then div id: 'menu-block'
      div className: 'top-area',
        a href: '/',
          div className: 'logo'
        div className: umClasses, onClick: @handleOpenMenu,
          div className: 'userMenu-wrapper', onClick: @handleCloseMenu
          span className: 'icon icon-right'
          ul className: 'userMenu-content', onClick: @handleCloseMenu,
            li {},
              a href: '/profile', @getIntlMessage 'edit-profile'
            li {},
              a
                className: 'logout'
                onClick: @handleLogout
                @getIntlMessage 'logout'

        if @context.user
          UserBrief user: @context.user
        div className: 'top-area',
          span className: 'indicator-position',
            Indicator {}
            @getIntlMessage 'active'
      div className: 'middle-area',
        @state.servicetypes.map (servicetype) ->
          sessions = _this.state.sessionsByServiceType[servicetype.id] || []
          SessionTypeTab
            key: servicetype.id
            sessionType: servicetype
            sessions: sessions
      div className: 'bottom-area',
        div className: 'title',
          @getIntlMessage 'next-event'
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