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

  componentWillMount: ->
    ServiceActions.refresh()

  componentDidMount: ->
    document.addEventListener 'click', @handleDocumentClick

  componentWillUnmount: ->
    document.removeEventListener 'click', @handleDocumentClick

  handleDocumentClick: ->
    @setState userMenuExpanded: false
    e.nativeEvent.stopImmediatePropagation()

  handleUserMenuClick: (e) ->
    @setState userMenuExpanded: true
    e.nativeEvent.stopImmediatePropagation()

  handleLogout: ->
    UserActions.logout()
    @handleDocumentClick()

  handleNothing: ->
    console.log 'Nothing handled'
    @handleDocumentClick()

  render: ->
    umClasses = 'userMenu'
    if @state.userMenuExpanded
      umClasses += ' is-expanded'

    sessTypes = ServiceStore.getAll()
    sessTypes.push {} # TODO: Fix this sucker!

    div id: 'menu',
      div className: 'top-area',
        div className: 'logo'
        div className: umClasses, onClick: @handleUserMenuClick,
          span className: 'icon icon-right'
          ul className: 'userMenu-content',
            li onClick: @handleNothing, 'Do nothing'
            li onClick: @handleLogout, @getIntlMessage('logout')
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