React = require 'react'
{ select } = React.DOM

module.exports = React.createClass
  render: ->
    select(
      className: 'select-form'
      name: @props.name
      , @props.options
    )