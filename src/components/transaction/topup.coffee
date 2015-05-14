React = require 'react'
ReactIntl = require '../../mixins/ReactIntl'

TransactionActions = require '../../actions/TransactionActions'
PageActions = require '../../actions/PageActions'

IconButton = React.createFactory require '../common/iconbutton'
#FormattedNumber = React.createFactory ReactIntl.FormattedNumber

{ div, a, span } = React.DOM

module.exports = React.createClass

  displayName: 'topUp'

  mixins: [ReactIntl.IntlMixin]

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

  handlePaymentsClick: ->
    PageActions.navigate '/top-up/payments'

  handleTopupClick: ->
    srvId = @props.serviceId
    if srvId
      redirectUrls = {}
      redirectUrls.cancel = '/#transaction/url/cancel'
      redirectUrls.success = '/#transaction/success/session?serviceId=' + srvId

    promise = TransactionActions.createPaypal @state.amount, redirectUrls
    @setState wait: true

  render: ->
    label =  @getIntlMessage 'view-payment-history'
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
              "#{(n / 100)} €"
      div className: 'topup-history',
        div className: 'label',
          @getIntlMessage('view-payment-history-message')
        IconButton icon: 'coin', url:'/top-up/payments', label: label
      div className: 'button', onClick: @handleTopupClick,
        @getIntlMessage 'top-up'