React = require 'react'
_ = require 'underscore'

{ div, label, input, span } = React.DOM

module.exports = React.createClass

  displayName: 'toggleInput'

  statics: linkType: 'value'

  contextTypes:
    editable: React.PropTypes.bool

  render: ->
    if @context.editable
      child = input _.omit @props, 'id', 'label'
    else
      child = span {}, @props.valueLink.value

    div className:'comp-toggleInput',
      div className: 'label',
        label {}, @props.label
      div className: 'field', child