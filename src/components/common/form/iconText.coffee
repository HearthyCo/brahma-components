React = require 'react'
_ = require 'underscore'

{ div, label, input, span } = React.DOM

module.exports = React.createClass

  displayName: 'text'

  render: ->
    div id: @props.id, className: 'field-set comp-text',
      label className: 'label',
        span className: 'icon icon-' + @props.icon
      input _.extend _.omit(@props, 'id', 'icon'), className: 'field'
      div className: 'message',
        label className: 'message-form'