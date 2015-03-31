React = require 'react'
_ = require 'underscore'

{ div, label, input, span } = React.DOM

module.exports = React.createClass

  displayName: 'text'

  render: ->
    omit = _.omit(@props, 'id', 'icon')

    _className = 'field-set comp-text'
    _className += " error" if @props.error

    div id: @props.id, className: _className,
      label className: 'label',
        span className: 'icon icon-' + @props.icon
      input _.extend omit, className: 'field', ref: 'input'
      div className: 'message',
        label className: 'message-form'
