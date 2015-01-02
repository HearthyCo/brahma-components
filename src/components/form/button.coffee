React = require 'react'

{div, button} = React.DOM

module.exports = React.createClass
  render: ->
    return (div { className: "field-set" },
      (button { type: "submit"}, @props.fieldName)
    )