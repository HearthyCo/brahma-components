React = require 'react'
input = require './input'
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
          name: 'gender'
          type: 'radio'
        )
        , label(
          className: 'label-form'
          , 'Hombre'
        )
        , input(
          className: 'radio-form'
          name: 'gender'
          type: 'radio'
        )
        , label(
          className: 'label-form'
          , 'Mujer'
        )
      )
    )