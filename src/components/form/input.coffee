React = require 'react'

{div, label, input} = React.DOM

module.exports = React.createClass
  render: ->
    return (div { className: 'field-set' },
      (div { className: 'field' },
        (label { className: 'label-form' }, @props.fieldName)
      )
      (div { className: 'field' },
        (input {
          className: 'input-form',
          placeholder: @props.fieldName
          type: @props.type
        })
      )
    )