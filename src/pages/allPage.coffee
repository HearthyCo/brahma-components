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
ProfessionalBrief = rcf require '../components/user/professionalBrief'

SessionStore = require '../stores/SessionStore'
s1 = new SessionStore {id: 33, title: 'Pediatría', startDate: new Date()}
s2 = new SessionStore {id: 22, title: 'Cardiología', startDate: new Date()}
UserStore = require '../stores/UserStore'
u1 = new UserStore {
  id: 44, name: 'Sverianiano', surname1: 'Fernandez', service: 'Otorrino',
  avatar: 'http://comps.canstockphoto.com/can-stock-photo_csp6253298.jpg'
}

{ div, span, a } = React.DOM

module.exports = React.createClass

  mixins: [ReactIntl]

  render: ->
    example = @getIntlMessage('example')
    icon = 'language'
    iconPlus = 'error'
    sessions = [s1, s2]
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
        TimelineEntry session: s1
        TimelineEntry session: s2
      div className: 'entry',
        div className: 'title', 'ProfessionalBrief'
        ProfessionalBrief user: u1