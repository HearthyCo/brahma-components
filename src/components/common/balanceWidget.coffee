React = require 'react/addons'
ReactIntl = require 'react-intl'
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
    amount = @props.amount or 12900 # or @context.user.credits

    div id: @props.id, className: 'comp-balancewidget',
      div className: 'icon icon-clock'
      div className: 'label', @getIntlMessage('actual-balance')
      div className: 'amount', @formatNumber(amount / 100, 'credits')