React = require 'react'
ReactIntl = require 'react-intl'

{ div, a } = React.DOM

module.exports = React.createClass

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    quantities: React.PropTypes.array

  getDefaultProps: ->
    quantities: [1000, 2000, 3000, 4000, 5000, 6000]

  getInitialState: () ->
    amount: @props.quantities[0]

  setAmount: (amount) ->
    @setState amount: amount

  getAmountSetter: (amount) ->
    setAmount = @setAmount
    ->
      setAmount amount

  render: ->
    _this = @

    div id: @props.id, className: 'comp-topup',
      div className: 'topup-quantitypick',
        div className: 'label',
          @getIntlMessage('top-up-select')
        div className: 'topup-amounts',
          @props.quantities.map (n) ->
            classes = 'topup-amount'
            if _this.state.amount is n
              classes += ' active'
            div className: classes, key: n, onClick: _this.getAmountSetter(n),
              _this.formatNumber n / 100, 'credits'
      div className: 'topup-confirm',
        div className: 'label',
          @formatMessage @getIntlMessage('top-up-confirm'),
            amount: @state.amount / 100
        div className: 'button',
          @getIntlMessage 'top-up'