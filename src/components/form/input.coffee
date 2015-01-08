React = require 'react'
{ input } = React.DOM

module.exports = React.createClass

  handleChange: (e) ->
    if @props.callback
      @props.callback @props.name, e.target.value

  render: ->
    input(
      className: 'input-form'
      name: @props.name
      placeholder: @props.placeholder
      type: @props.type
      value: @props.value
      onChange: @handleChange
    )