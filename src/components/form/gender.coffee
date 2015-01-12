React = require 'react'
ReactIntlMixin = require 'react-intl'

radio = React.createFactory require './radio'
{ div, label } = React.DOM

module.exports = React.createClass
  mixins: [ ReactIntlMixin ]

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
          label: @getIntlMessage('male')
          name: @props.name
          value: 'MALE'
          checked: @props.value is 'MALE'
          callback: @props.callback
        )
        , radio(
          label: @getIntlMessage('female')
          name: @props.name
          value: 'FEMALE'
          checked: @props.value is 'FEMALE'
          callback: @props.callback
        )
        , radio(
          label: @getIntlMessage('other')
          name: @props.name
          value: 'OTHER'
          checked: @props.value is 'OTHER'
          callback: @props.callback
        )
      )
      , div(
        className: 'message'
        , label(
          className: 'message-form'
        )
      )
    )