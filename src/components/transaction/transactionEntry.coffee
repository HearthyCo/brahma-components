React = require 'react'
ReactIntl = require '../../mixins/ReactIntl'

FormattedDate = React.createFactory ReactIntl.FormattedDate
FormattedNumber = React.createFactory ReactIntl.FormattedNumber

{ div, img, span, a } = React.DOM

module.exports = React.createClass

  displayName: 'transactionentry'

  mixins: [ReactIntl.IntlMixin]

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
    reason = @props.transaction.reason.toLowerCase().replace '_', '-'
    reason = @getIntlMessage 'transaction-' + reason

    div id: @props.id, className: 'comp-transactionentry amount-' + extraClass,
      div className: 'transaction-label',
        div className: 'session-reason', reason
        div className: 'session-title', @props.transaction.title
      div className: 'transation-date',
        span className: 'date',
          FormattedDate
            value: @props.transaction.timestamp
            day: "numeric"
            month: "numeric"
            year: "numeric"
      div className: 'transaction-value',
        span className: 'sign', sign
        span className: 'amount',
          FormattedNumber
            value:(Math.abs(@props.transaction.amount) / 100)
            style: 'currency'
            currency: 'EUR'
