React = require 'react'
{ input } = React.DOM

module.exports = React.createClass
  render: ->
    input(
      className: 'radio-form'
      name: @props.name
      type: 'radio'
      value: @props.value
      , @props.label
    )