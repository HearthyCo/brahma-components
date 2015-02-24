React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

{ div, ul, li, span, a } = React.DOM
UserBrief = React.createFactory require '../user/userBrief'
SessionTypeTab = React.createFactory require '../session/sessionTypeTab'

ServiceActions = require '../../actions/ServiceActions'
UserActions = require '../../actions/UserActions'
ServiceStore = require '../../stores/ServiceStore'

module.exports = React.createClass

  displayName: 'professionalMenu'

  mixins: [ReactIntl]

  contextTypes:
    user: React.PropTypes.object

  getInitialState: ->
    userMenuExpanded: false
    services: []

  componentWillMount: ->
    ServiceActions.refresh()

  componentDidMount: ->
    ServiceStore.addChangeListener @updateServices

  componentWillUnmount: ->
    ServiceStore.removeChangeListener @updateServices

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

  updateServices: ->
    @setState services: ServiceStore.getAll()


  render: ->
    umClasses = 'userMenu'
    if @state.userMenuExpanded
      umClasses += ' is-expanded'

    sessTypes = @state.services
    sessTypes.push {} # TODO: Fix this sucker!

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
        Object.keys(sessTypes[0]).map (field) ->
          ret = sessTypes[0][field].map (st) ->
            sessions = [
              {
                "id": 90700,
                "title": "testSession1",
              },
              {
                "id": 90704,
                "title": "testSession5",
              },
              {
                "id": 90708,
                "title": "testSession2",
              }
            ] # TODO: Remove sample data ^^^
            SessionTypeTab key: st.id, sessionType: st, sessions: sessions
          ret.key = field
          ret
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