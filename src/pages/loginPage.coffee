React = require 'react/addons'
_ = require 'underscore'

LoginForm = React.createFactory require '../components/user/loginForm'

{ div, span, a } = React.DOM

module.exports = React.createClass

  displayName: 'loginPage'
  statics:
    sectionName: 'externalSection'
    isPublic: true

  render: ->
    div className: 'page-loginPage',
      LoginForm {}
