React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

HomeStore = require '../stores/HomeStore'

HomeActions = require '../actions/HomeActions'
UserActions = require '../actions/UserActions'

MainlistEntry = React.createFactory require '../components/common/mainlistEntry'
TransactionEntry = React.createFactory(
  require '../components/transaction/transactionEntry'
)
SessionList = React.createFactory require '../components/session/sessionList'
IconButton = React.createFactory require '../components/common/iconbutton'
HistoryBrief = React.createFactory require '../components/history/historyBrief'
BalanceWidget = React.createFactory require '../components/common/balanceWidget'

{ div, a } = React.DOM

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
    #--------------- Sessions
    sessions = []
    newSessions = 0
    for key, entries of @state.data.sessions
      entries.map (s) -> if s.isNew then ++newSessions
      opts =
        title: @getIntlMessage(key)
        key: key
        url: '/sessions/' + key
        sessions: entries
      sessions.push SessionList opts

    sessionsOpts =
      label: @getIntlMessage('sessions')
      value: newSessions
      icon: 'clock'
      id: 'sessions'

    #--------------- History
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
      icon: 'history'
      id: 'history'

    #--------------- Balance
    ctxUser = @context.user
    balance = if ctxUser then ctxUser.balance else 0
    transactions = []
    if @state.data.balance
      balance = @state.data.balance.amount
      transactions = @state.data.balance.transactions.map (transaction) ->
        TransactionEntry key: transaction.id, transaction: transaction

      transactions.unshift div className: 'label payment-history-home',
        @getIntlMessage 'payment-history'
      transactions.unshift BalanceWidget amount: balance
      transactions.push a
        key: 'view-more'
        className: 'view-more transactions-view-more'
        href: '/top-up/payments',
        @getIntlMessage 'view-more'
      transactions.push a className: 'button', href: '/top-up',
        @getIntlMessage 'top-up'

    balanceOpts =
      label: @getIntlMessage 'balance'
      value: 0
      icon: 'pig'
      #target: '/top-up'
      id: 'balance'

    #--------------- Config
    configOpts =
      label: @getIntlMessage 'config'
      value: 0
      icon: 'gear'
      id: 'config'

    logout =
      label: @getIntlMessage 'logout'
      icon: 'close'
      onClick: UserActions.logout

    #--------------- New Session
    newSession =
      label: @getIntlMessage 'new-session'
      icon: 'plus-2'
      url: '/session-new'

    div className: 'page-home',
      MainlistEntry sessionsOpts,
        sessions
      MainlistEntry historyOpts,
        histories
      MainlistEntry balanceOpts,
        transactions
      MainlistEntry configOpts,
        IconButton logout
      div className: 'new-session',
        IconButton newSession
