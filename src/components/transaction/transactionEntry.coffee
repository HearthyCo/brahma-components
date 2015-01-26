React = require 'react'
ReactIntl = require 'react-intl'

{ div, img, span, a } = React.DOM

module.exports = React.createClass

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
        div className: 'session-date',
          span className: 'date',
            @formatDate @props.transaction.timestamp, 'dateonly'
          span className: 'time',
            @formatTime @props.transaction.timestamp, 'time'
        div className: 'session-title', @props.transaction.title
        div className: 'session-profesional',
      div className: 'transaction-value',
        span className: 'sign', sign
        span className: 'amount', amount