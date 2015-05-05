React = require 'react'
ReactIntl = require '../../../mixins/ReactIntl'
{ div, label, input } = React.DOM

module.exports = React.createClass

  displayName: 'gender'

  mixins: [ReactIntl]

  handleChange: (value, e) ->
    if @props.valueLink and e.target.checked
      @props.valueLink.requestChange value

  mkRadio: (opts) ->
    actualValue = if @props.valueLink then @props.valueLink.value

    opts.className = 'radio-form'
    opts.type = 'radio'
    opts.name = @props.name
    opts.value = opts.value
    opts.checked = actualValue is opts.value
    opts.onChange = @handleChange.bind(@, opts.value)

    div className: 'field-radio gender-' + opts.value.toLowerCase(),
      label {},
        input opts
        opts.label

  render: ->
    male =
      label: @getIntlMessage('male')
      value: 'MALE'

    female =
      label: @getIntlMessage('female')
      value: 'FEMALE'

    if @props.required
      male.required = true
      female.required = true

    div id: @props.id, className: 'field-set comp-gender',
      div className: 'label',
        label className: 'label-form',
          @props.label
      div className: 'field',
        @mkRadio male
        @mkRadio female
      div className: 'message',
        label className: 'message-form'