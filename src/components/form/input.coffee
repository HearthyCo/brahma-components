React = require 'react'
{ input } = React.DOM

module.exports = React.createClass
  render: ->
    input(
      className: 'input-form'
      name: @props.name
      placeholder: @props.label
      type: @props.type
      value: @props.value
    )