React = require 'react'
_ = require 'underscore'

{ div, label, input } = React.DOM

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
        , input _.omit @props, 'id'
      )
      , div(
        className: 'message'
        , label(
          className: 'message-form'
        )
      )
    )