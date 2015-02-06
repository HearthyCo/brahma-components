React = require 'react'
ReactIntl = require 'react-intl'

{ div, a } = React.DOM

module.exports = React.createClass

  displayName: 'topUp'

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

  goPay: (amount) ->
    Backbone = require 'exoskeleton'
    Backbone.ajax
      url: window.apiServer + '/v1/transaction'
      contentType: "application/json; charset=utf-8"
      type: 'POST'
      dataType: 'jsonp'
      data: amount: @state.amount
      success: (result) ->
        try
          url = result.transaction.meta.paypal.links[1].href
          console.log 'Redirecting to paypal at:', url
          window.location url
        catch e
          console.error 'Can\'t redirect to paypal:', e, result
      error: (xhr, status) ->
        console.error 'Can\t redirect to paypal:', status, xhr


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
        div className: 'button', onClick: @goPay,
          @getIntlMessage 'top-up'