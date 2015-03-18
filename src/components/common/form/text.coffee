React = require 'react'
_ = require 'underscore'

{ div, label, input } = React.DOM

module.exports = React.createClass

  displayName: 'text'

  render: ->

    id = "input-#{@props.id}"

    div id: @props.id, className: 'field-set comp-text',
      div className: 'label',
        label className: 'label-form', htmlFor: id,
          @props.label

      div className: 'field',
        input _.extend @props, { id: id }
      div className: 'message',
        label className: 'message-form'