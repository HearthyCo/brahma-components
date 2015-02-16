React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

{ div, ul, li, span } = React.DOM
UserBrief = React.createFactory require '../user/userBrief'

UserActions = require '../../actions/UserActions'

module.exports = React.createClass

  displayName: 'professionalMenu'

  mixins: [ReactIntl]

  contextTypes:
    user: React.PropTypes.object

  getInitialState: ->
    userMenuExpanded: false

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
