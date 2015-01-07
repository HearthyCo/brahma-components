React = require 'react'
{ div, label, input } = React.DOM

module.exports = React.createClass
  render: ->
    input(
      className: @props.className
      name: @props.name
      placeholder: @props.label
      type: @props.type
    )