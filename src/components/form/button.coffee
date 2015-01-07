React = require 'react'
{ div, button } = React.DOM

module.exports = React.createClass
  render: ->
    div(
      className: "field-set"
      , button(
        type: "submit"
        , @props.label
      )
    )