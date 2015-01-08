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
          className: 'radio-form'
          name: @props.name
          value: 'MALE'
          type: 'radio'
        )
        , label(
          className: 'label-form'
          , 'Hombre'
        )
        , input(
          className: 'radio-form'
          name: @props.name
          value: 'FEMALE'
          type: 'radio'
        )
        , label(
          className: 'label-form'
          , 'Mujer'
        )
        , input(
          className: 'radio-form'
          name: @props.name
          value: 'OTHER'
          type: 'radio'
        )
        , label(
          className: 'label-form'
          , 'Otro'
        )
      )
    )