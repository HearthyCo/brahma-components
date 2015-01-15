React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

SignupForm = React.createFactory require '../components/user/signupForm'
LoginForm = React.createFactory require '../components/user/loginForm'
MainlistEntry = React.createFactory require '../components/common/mainlistEntry'
SessionList = React.createFactory require '../components/common/sessionList'

{ div, span, a } = React.DOM

module.exports = React.createClass

  mixins: [ReactIntl]

  render: ->
    example = @getIntlMessage('example')
    icon = 'https://cdn0.iconfinder.com/data/icons/typicons-2/24/tick-256.png'
    sessions = [
      {id: 33, title: 'Pediatría', startDate: new Date()},
      {id: 22, title: 'Cardiología', startDate: new Date(1420066740000)}
    ]
    url = '/sessions/programmed'

    div className: 'page-allPage',
      div className: 'entry',
        div className: 'title', 'SignupForm'
        SignupForm {}
      div className: 'entry',
        div className: 'title', 'LoginForm'
        LoginForm {}
      div className: 'entry',
        div className: 'title', 'MainlistEntry'
        MainlistEntry label: example, value: 33, icon: icon,
          SessionList title: example, url: url, sessions: sessions
          SessionList title: example, url: url, sessions: sessions
          SessionList title: example, url: url, sessions: sessions
