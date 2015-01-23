React = require 'react/addons'
_ = require 'underscore'

LoginForm = React.createFactory require '../components/user/loginForm'

{ div, span, a } = React.DOM

module.exports = React.createClass

  displayName: 'loginPage'

  render: ->
    div className: 'page-loginPage',
      LoginForm {}
