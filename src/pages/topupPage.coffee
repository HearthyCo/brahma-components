React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

TopUp = React.createFactory require '../components/transaction/topup'
IconButton = React.createFactory require '../components/common/iconbutton'
BalanceWidget = React.createFactory require '../components/common/balanceWidget'

{ div, span, a } = React.DOM

module.exports = React.createClass

  displayName: 'topupPage'
  statics: sectionName: 'balanceSection'

  mixins: [ReactIntl]

  render: ->
    viewHistory = @getIntlMessage('view-payment-history')

    div className: 'page-topupPage',
      BalanceWidget {}
      TopUp {}
      IconButton icon: 'coin', label: viewHistory, url: '/top-up/payments'
