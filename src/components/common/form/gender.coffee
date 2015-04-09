React = require 'react'
ReactIntl = require '../../../mixins/ReactIntl'
{ div, label, input } = React.DOM

module.exports = React.createClass

  displayName: 'gender'

  mixins: [ReactIntl]

  handleChange: (value, e) ->
    if @props.valueLink and e.target.checked
      @props.valueLink.requestChange value

  mkRadio: (labelValue, value) ->
    actualValue = if @props.valueLink then @props.valueLink.value
    div className: 'field-radio gender-' + value.toLowerCase(),
      label {},
        input
          className: 'radio-form', type: 'radio'
          name: @props.name, value: value, checked: (actualValue is value)
          onChange: @handleChange.bind(@, value)
        labelValue

  render: ->
    male = @getIntlMessage('male')
    female = @getIntlMessage('female')
    other = @getIntlMessage('other')

    div id: @props.id, className: 'field-set comp-gender',
      div className: 'label',
        label className: 'label-form',
          @props.label
      div className: 'field',
        @mkRadio male, 'MALE'
        @mkRadio female, 'FEMALE'
        @mkRadio other, 'OTHER'
      div className: 'message',
        label className: 'message-form'