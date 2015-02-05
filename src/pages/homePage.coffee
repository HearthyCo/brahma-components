React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

HomeStore = require '../stores/HomeStore'

HomeActions = require '../actions/HomeActions'
UserActions = require '../actions/UserActions'

MainlistEntry = React.createFactory require '../components/common/mainlistEntry'
SessionList = React.createFactory require '../components/session/sessionList'
IconButton = React.createFactory require '../components/common/iconbutton'
HistoryBrief = React.createFactory require '../components/history/historyBrief'

{ div } = React.DOM

module.exports = React.createClass

  displayName: 'homePage'
  statics: sectionName: 'homeSection'

  mixins: [ReactIntl]

  getInitialState: ->
    data: HomeStore.getAll()

  contextTypes:
    user: React.PropTypes.object

  componentDidMount: ->
    HomeStore.addChangeListener @updateState
    HomeActions.refresh()

  componentWillUnmount: ->
    HomeStore.removeChangeListener @updateState

  updateState: () ->
    @setState { data: HomeStore.getAll() }

  render: ->
    sessions = []
    newSessions = 0
    for key, entries of @state.data.sessions
      entries.map (s) -> if s.isNew then newSessions++
      opts =
        title: @getIntlMessage(key)
        key: key
        url: '/sessions/' + key
        sessions: entries
      sessions.push SessionList opts

    sessionsOpts =
      label: @getIntlMessage('sessions')
      value: newSessions
      icon: 'reloj'
      id: 'sessions'

    # vvv TEST CONTENT BELOW vvv
    histories = HistoryBrief history:
      allergies: [
        {id: 1, title: 'Trigo', description: 'Ronchas a mansalva'}
        {id: 2, title: 'Pescado', description: 'Muerte cerebroide'}
      ]
    newHistories = 2
    # ^^^ /TEST ^^^
    historyOpts =
      label: @getIntlMessage('history')
      value: newHistories
      icon: 'historial'
      id: 'history'

    ctxUser = @context.user
    balance = @state.data.balance || if ctxUser then ctxUser.balance else 0
    balanceOpts =
      label: @getIntlMessage('balance')
      value: 0
      icon: 'cerdito'
      extra: @formatNumber(balance / 100, 'credits')
      target: '/top-up'
      id: 'balance'

    configOpts =
      label: @getIntlMessage('config')
      value: 0
      icon: 'payment'
      id: 'config'

    logout =
      label: @getIntlMessage('logout')
      icon: 'close'
      onClick: UserActions.logout

    newSession =
      label: @getIntlMessage('new-session')
      icon: 'cross'
      url: '/session-new'

    div className: 'page-home',
      MainlistEntry sessionsOpts,
        sessions
      MainlistEntry historyOpts,
        histories
      MainlistEntry balanceOpts
      MainlistEntry configOpts,
        IconButton logout
      div className: 'new-session',
        IconButton newSession
