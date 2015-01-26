React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

rcf = React.createFactory
BalanceWidget = rcf require '../components/common/balanceWidget'
TransactionEntry = rcf require '../components/transaction/transactionEntry'

{ div, span, a } = React.DOM

module.exports = React.createClass

  displayName: 'paymentsPage'

  mixins: [ReactIntl]

  render: ->
    payments = [
      {
        id: 91300,
        amount: -1000,
        timestamp: 1418626800000,
        reason: "Reserva de sesión",
        title: "testSession1"
      }
    ]

    div className: 'page-topupPage',
      BalanceWidget {}
      a className: 'button', href: '/top-up', @getIntlMessage('top-up')
      div className: 'label', @getIntlMessage('payment-history')
      div className: 'transactions',
        payments.map (transaction) ->
          TransactionEntry key: transaction.id, transaction: transaction

