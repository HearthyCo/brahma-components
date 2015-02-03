React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

rcf = React.createFactory
SignupForm = rcf require '../components/user/signupForm'
LoginForm = rcf require '../components/user/loginForm'
BreadCrumb = rcf require '../components/common/breadcrumb'
MainlistEntry = rcf require '../components/common/mainlistEntry'
SessionList = rcf require '../components/session/sessionList'
IconButton = rcf require '../components/common/iconbutton'
TimelineEntry = rcf require '../components/session/timelineEntry'
ProfessionalBrief = rcf require '../components/user/professionalBrief'
TopUp = rcf require '../components/transaction/topup'
BalanceWidget = rcf require '../components/common/balanceWidget'
TransactionEntry = rcf require '../components/transaction/transactionEntry'
AllergyEntry = rcf require '../components/history/allergyEntry'
HistoryBrief = rcf require '../components/history/historyBrief'

s1 = {id: 33, title: 'Pediatría', startDate: new Date()}
s2 = {id: 22, title: 'Cardiología', startDate: new Date()}
sessions = [s1, s2]
u1 = {id: 44, name: 'Sverianiano', surname1: 'Fernandez', service: 'Otorrino'}
t1 = {
  id: 91300, amount: -1000, timestamp: 1418626800000,
  reason: "Reserva de sesión", title: "testSession1"
}
list = [
  { label: 'Home', link: '/', className: 'home' },
  { label: 'Sessions', link: '/sessions', className: 'clock' },
  { label: s1.title, link: '/sessions/' + s1.id, className: 'clock' }
]
a1 = id: 55, title: 'Gramíneas', description: 'Se pone mu malo', meta: rating: 4
a2 = id: 66, title: 'Trigo', description: 'Ai que se nos vai!', meta: rating: 2
h = { allergies: [a1, a2]}

{ div, span, a } = React.DOM

module.exports = React.createClass

  displayName: 'allPage'
  statics: sectionName: 'develSection'

  mixins: [ReactIntl]

  render: ->
    example = @getIntlMessage('example')
    icon = 'language'
    iconPlus = 'error'
    url = '/sessions/programmed'

    div className: 'page-allPage',
      div className: 'entry',
        div className: 'robocop', 'SignupForm'
        SignupForm {}
      div className: 'entry',
        div className: 'robocop', 'LoginForm'
        LoginForm {}
      div className: 'entry',
        div className: 'robocop', 'BreadCrumb'
        BreadCrumb list: list
      div className: 'entry',
        div className: 'robocop', 'MainlistEntry'
        MainlistEntry label: example, value: 33, icon: icon,
          SessionList title: example, url: url, sessions: sessions
          SessionList title: example, url: url, sessions: sessions
          SessionList title: example, url: url, sessions: sessions
      div className: 'entry',
        div className: 'robocop', 'IconButton'
        IconButton label: example, icon: iconPlus, url: url
      div className: 'entry',
        div className: 'robocop', 'TimelineEntry'
        TimelineEntry session: s1
        TimelineEntry session: s2
      div className: 'entry',
        div className: 'robocop', 'ProfessionalBrief'
        ProfessionalBrief user: u1
      div className: 'entry',
        div className: 'robocop', 'TopUp'
        TopUp {}
      div className: 'entry',
        div className: 'robocop', 'BalanceWidget'
        BalanceWidget amount: 12300
      div className: 'entry',
        div className: 'robocop', 'TransactionEntry'
        TransactionEntry transaction: t1
      div className: 'entry',
        div className: 'robocop', 'AllergyEntry'
        AllergyEntry allergy: a1
        AllergyEntry allergy: a2
      div className: 'entry',
        div className: 'robocop', 'HistoryBrief'
        HistoryBrief history: h, profile: u1
