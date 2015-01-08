React = require 'react'
input = React.createFactory require './input'
{ div, label } = React.DOM

module.exports = React.createClass
  render: ->
    div(
      id: @props.id
      className: 'field-set'
      , div(
        className: 'label'
        , label(
          className: 'label-form'
          , @props.label
        )
      )
      , div(
        className: 'field'
        , input(
          name: @props.name
          placeholder: @props.label
          type: @props.type
        )
      )
      , div(
        className: 'message'
        , label(
          className: 'message-form'
        )
      )
    )