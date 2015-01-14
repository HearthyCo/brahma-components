React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

SignupForm = React.createFactory require '../components/user/signupForm'
LoginForm = React.createFactory require '../components/user/loginForm'
MainlistEntry = React.createFactory require '../components/common/mainlistEntry'

{ div, span, a } = React.DOM

module.exports = React.createClass

  mixins: [ReactIntl]

  render: ->
    example = @getIntlMessage('example')

    div className: 'page-allPage',
      div className: 'entry',
        div className: 'title', "SignupForm"
        SignupForm {}
      div className: 'entry',
        div className: 'title', "LoginForm"
        LoginForm {}
      div className: 'entry',
        div className: 'title', "MainlistEntry"
        MainlistEntry label: example, value: 33, icon: "https://cdn0.iconfinder.com/data/icons/typicons-2/24/tick-256.png"
