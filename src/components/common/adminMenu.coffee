React = require 'react/addons'
ReactIntl = require '../../mixins/ReactIntl'
_ = require 'underscore'

{ div, ul, li, span, a } = React.DOM
UserBrief = React.createFactory require '../user/userBrief'

UserActions = require '../../actions/UserActions'

module.exports = React.createClass

  displayName: 'adminMenu'

  mixins: [ReactIntl]

  contextTypes:
    user: React.PropTypes.object

  handleLogout: ->
    UserActions.logout()

  render: ->
    div id: 'menu',
      div className: 'top-area',
        a href: '/',
          div className: 'logo'
      div className: 'middle-area',
        a href: '/crud/professional', 'Professionals'
        a href: '#', onClick: @handleLogout, 'Logout'