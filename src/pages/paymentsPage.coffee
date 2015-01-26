React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

TransactionStore = require '../stores/TransactionStore'

TransactionActions = require '../actions/TransactionActions'

rcf = React.createFactory
BalanceWidget = rcf require '../components/common/balanceWidget'
TransactionEntry = rcf require '../components/transaction/transactionEntry'

{ div, span, a } = React.DOM

module.exports = React.createClass

  displayName: 'paymentsPage'

  mixins: [ReactIntl]

  getInitialState: ->
    transactions: TransactionStore.getAll()

  componentDidMount: ->
    TransactionStore.addChangeListener @updateState
    TransactionActions.refresh()

  componentWillUnmount: ->
    TransactionStore.removeChangeListener @updateState

  updateState: () ->
    @setState transactions: TransactionStore.getAll()

  render: ->
    div className: 'page-topupPage',
      BalanceWidget {}
      a className: 'button', href: '/top-up', @getIntlMessage('top-up')
      div className: 'label', @getIntlMessage('payment-history')
      div className: 'transactions',
        @state.transactions.map (transaction) ->
          TransactionEntry key: transaction.id, transaction: transaction

