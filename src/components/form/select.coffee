React = require 'react'
{ select } = React.DOM

module.exports = React.createClass

  handleChange: (e) ->
    if @props.callback
      @props.callback @props.name, e.target.value


  render: ->
    select(
      className: 'select-form'
      name: @props.name
      onChange: @handleChange
      , @props.options
    )