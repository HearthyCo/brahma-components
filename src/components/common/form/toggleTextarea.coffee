React = require 'react'
_ = require 'underscore'

{ div, label, textarea, span } = React.DOM

module.exports = React.createClass

  displayName: 'toggleTextarea'

  contextTypes:
    editable: React.PropTypes.bool

  render: ->
    if @context.editable
      child = textarea _.omit @props, 'id', 'label'
    else
      child = span {}, @props.valueLink.value

    div className:'comp-toggleTextarea',
      div className: 'label',
        label {}
      div className: 'field', child