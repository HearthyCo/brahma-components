React = require 'react'
{ div, button } = React.DOM

module.exports = React.createClass
  render: ->
    div(
      id: @props.id
      className: 'field-set'
      , button(
        type: 'submit'
        , @props.label
      )
    )