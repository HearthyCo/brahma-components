React = require 'react/addons'
ReactIntl = require '../../mixins/ReactIntl'
_ = require 'underscore'

FormattedNumber = React.createFactory ReactIntl.FormattedNumber

{ div, a, span } = React.DOM

module.exports = React.createClass

  displayName: 'balanceWidget'

  mixins: [ReactIntl.IntlMixin]

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
      div className: 'amount',
        FormattedNumber
          value:(amount / 100), style: 'currency', currency: 'EUR'
