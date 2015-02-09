React = require 'react'
ReactIntl = require 'react-intl'

{ div, img, span, a } = React.DOM

module.exports = React.createClass

  displayName: 'transactionentry'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    transaction: React.PropTypes.object.isRequired


  render: ->
    if @props.transaction.amount < 0
      sign = '-'
      extraClass = 'minus'
    else
      sign = '+'
      extraClass = 'plus'
    amount = @formatNumber Math.abs(@props.transaction.amount) / 100, 'credits'

    div id: @props.id, className: 'comp-transactionentry amount-' + extraClass,
      div className: 'transaction-label',
        div className: 'session-reason', @props.transaction.reason
        div className: 'session-title', @props.transaction.title
      div className: 'transation-date',
        span className: 'date',
          @formatDate @props.transaction.timestamp, 'dateonly'
      div className: 'transaction-value',
        span className: 'sign', sign
        span className: 'amount', amount