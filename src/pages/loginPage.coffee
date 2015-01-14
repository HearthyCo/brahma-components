React = require 'react/addons'
_ = require 'underscore'

LoginForm = React.createFactory require '../components/user/loginForm'

{ div, span, a } = React.DOM

module.exports = React.createClass
  render: ->
    div className: 'loginPage',
      LoginForm {}
