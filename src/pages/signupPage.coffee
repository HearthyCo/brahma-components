React = require 'react/addons'
_ = require 'underscore'

SignupForm = React.createFactory require '../components/user/signupForm'

{ div, span, a } = React.DOM

module.exports = React.createClass

  displayName: 'signupPage'
  statics: sectionName: 'externalSection'

  render: ->
    div className: 'page-signupPage',
      SignupForm {}
