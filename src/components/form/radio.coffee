React = require 'react'
{ input } = React.DOM

module.exports = React.createClass

  handleChange: (e) ->
    if @props.callback && e.target.checked
      @props.callback @props.name, e.target.value

  render: ->
    input(
      className: 'radio-form'
      name: @props.name
      type: 'radio'
      value: @props.value
      checked: @props.checked
      onChange: @handleChange
      , @props.label
    )