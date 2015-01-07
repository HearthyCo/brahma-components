React = require 'react'

{div, label, input} = React.DOM

module.exports = React.createClass
  render: ->
    return (div { className: 'field-set' },
      (div { className: 'field' },
        (label { className: 'label-form' }, @props.label)
      )
      (div { className: 'field' },
        (input {
          className: 'input-form'
          name: @props.name
          placeholder: @props.label
          type: @props.type
        })
      )
    )