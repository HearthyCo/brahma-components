React = require 'react/addons'
ReactIntl = require '../../mixins/ReactIntl'
_ = require 'underscore'

{ div, a, span } = React.DOM

module.exports = React.createClass

  displayName: 'balanceWidget'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    amount: React.PropTypes.number

  contextTypes:
    user: React.PropTypes.object

  render: ->
    amount = @props.amount or if @context.user then @context.user.balance else 0

    div id: @props.id, className: 'comp-balancewidget',
      div className: 'icon icon-pig'
      div className: 'label', @getIntlMessage('actual-balance')
      div className: 'amount', @formatNumber(amount / 100, 'credits')
