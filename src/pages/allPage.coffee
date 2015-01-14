React = require 'react/addons'
_ = require 'underscore'

SignupForm = React.createFactory require '../components/user/signupForm'
LoginForm = React.createFactory require '../components/user/loginForm'
MainlistEntry = React.createFactory require '../components/common/mainlistEntry'
Iconbadge = React.createFactory require '../components/common/iconbadge'

{ div, span, a } = React.DOM

module.exports = React.createClass
  render: ->
    div className: 'page-allPage',
      div className: 'entry',
        div className: 'title', "SignupForm"
        SignupForm {}
      div className: 'entry',
        div className: 'title', "LoginForm"
        LoginForm {}
      div className: 'entry',
        div className: 'title', "MainlistEntry"
        MainlistEntry label: "Example", value: "33", icon: "https://cdn0.iconfinder.com/data/icons/typicons-2/24/tick-256.png"
