React = require 'react'
_ = require 'underscore'

{ div, label, span, select, option } = React.DOM

module.exports = React.createClass

  displayName: 'toggleSelect'

  contextTypes:
    editable: React.PropTypes.bool

  render: ->

    # @props.value = @props.valueLink.value

    if @context.editable
      child = select _.omit(@props, 'id', 'label', 'options'),
        @props.options.map (op, i) ->
          option key: op, value: op,
            op
    else
      child = span {}, @props.valueLink.value

    div className:'comp-toggleSelect',
      div className: 'label',
        label {}, @props.label
      div className: 'field', child
