React = require 'react'
{ div, label, input } = React.DOM

module.exports = React.createClass

  handleChange: (value, e) ->
    if @props.valueLink and e.target.checked
      @props.valueLink.requestChange value


  mkRadio: (label, value) ->
    actualValue = if @props.valueLink then @props.valueLink.value
    input(
      className: 'radio-form'
      type: 'radio'
      label: label
      name: @props.name
      value: value
      checked: actualValue is value
      onChange: @handleChange.bind(@, value)
      , label
    )

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
        , @mkRadio('Hombre', 'MALE')
        , @mkRadio('Mujer', 'FEMALE')
        , @mkRadio('Otro', 'OTHER')
      )
      , div(
        className: 'message'
        , label(
          className: 'message-form'
        )
      )
    )