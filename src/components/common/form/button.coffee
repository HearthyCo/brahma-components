React = require 'react'
{ div, button } = React.DOM

module.exports = React.createClass

  displayName: 'button'

  render: ->
    div id: @props.id, className: 'field-set comp-button',
      button type: 'submit',
        @props.label
