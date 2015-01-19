React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

rcf = React.createFactory
SignupForm = rcf require '../components/user/signupForm'
LoginForm = rcf require '../components/user/loginForm'
MainlistEntry = rcf require '../components/common/mainlistEntry'
SessionList = rcf require '../components/session/sessionList'
IconButton = rcf require '../components/common/iconbutton'
TimelineEntry = rcf require '../components/session/timelineEntry'

{ div, span, a } = React.DOM

module.exports = React.createClass

  mixins: [ReactIntl]

  render: ->
    example = @getIntlMessage('example')
    icon = 'https://cdn0.iconfinder.com/data/icons/typicons-2/24/tick-256.png'
    iconPlus = 'http://www.icone-png.com/png/30/29952.png'
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
      div className: 'entry',
        div className: 'title', 'IconButton'
        IconButton label: example, icon: iconPlus, url: url
      div className: 'entry',
        div className: 'title', 'TimelineEntry'
        TimelineEntry session: sessions[0]
        TimelineEntry session: sessions[1]