React = require 'react'
_ = require 'underscore'

{ div, label, textarea } = React.DOM

module.exports = React.createClass

  displayName: 'toggleTextarea'

  render: ->
    div className:'comp-toggleTextarea',
      div className: 'label',
        label {},

      div className: 'field',
        textarea _.omit @props, 'id', 'label'