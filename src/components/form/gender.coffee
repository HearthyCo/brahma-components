React = require 'react'
radio = React.createFactory require './radio'
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
        , radio(
          label: 'Hombre'
          name: @props.name
          value: 'MALE'
        )
        , radio(
          label: 'Mujer'
          name: @props.name
          value: 'FEMALE'
        )
        , radio(
          label: 'Otro'
          name: @props.name
          value: 'OTHER'
        )
      )
      , div(
        className: 'message'
        , label(
          className: 'message-form'
        )
      )
    )