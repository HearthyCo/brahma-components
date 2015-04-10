React = require 'react'
ReactIntl = require '../../mixins/ReactIntl'
TransactionActions = require '../../actions/TransactionActions'

{ div, a } = React.DOM

module.exports = React.createClass

  displayName: 'topUp'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    quantities: React.PropTypes.array
    action: React.PropTypes.string
    serviceId: React.PropTypes.number

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

  handleTopupClick: ->
    srvId = @props.serviceId
    if srvId
      redirectUrls = {}
      redirectUrls.cancel = '/#transaction/url/cancel'
      redirectUrls.success = '/#transaction/success/session?serviceId=' + srvId

    promise = TransactionActions.createPaypal @state.amount, redirectUrls
    @setState wait: true

  render: ->
    _this = @

    if @state.wait
      return div id: "wait", @getIntlMessage 'moment-please'

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
        div className: 'button', onClick: @handleTopupClick,
          @getIntlMessage 'top-up'