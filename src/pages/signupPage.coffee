React = require 'react/addons'
_ = require 'underscore'

SignupForm = React.createFactory require '../components/user/signupForm'

{ div, span, a } = React.DOM

module.exports = React.createClass

  displayName: 'signupPage'

  render: ->
    div className: 'page-signupPage',
      SignupForm {}
