React = require 'react'
input = React.createFactory require './input'
{ div, label } = React.DOM

module.exports = React.createClass
  render: ->
    div(
      className: 'field-set'
      , div(
        className: 'field'
        , label(
          className: 'label-form'
          , @props.label
        )
      )
      , div(
        className: 'field'
        , input(
          className: 'input-form'
          name: @props.name
          placeholder: @props.label
          type: @props.type
        )
      )
    )