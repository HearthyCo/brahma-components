React = require 'react'
{ div, button } = React.DOM

module.exports = React.createClass
  render: ->
    div(
      id: @props.id
      className: 'field-set comp-button'
      , button(
        type: 'submit'
        , @props.label
      )
    )