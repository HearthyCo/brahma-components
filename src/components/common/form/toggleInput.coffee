React = require 'react'
_ = require 'underscore'

{ div, label, input } = React.DOM

module.exports = React.createClass

  displayName: 'toggleInput'

  render: ->
    div {},
      div className: 'label',
        label {}, @props.label

      div className: 'field',
        input _.omit @props, 'id', 'label'