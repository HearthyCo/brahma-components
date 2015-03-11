React = require 'react'
ReactIntl = require 'react-intl'
{ div, label, input, span } = React.DOM

module.exports = React.createClass

  displayName: 'trigger'

  mixins: [ReactIntl]
  propTypes:
    callback: React.PropTypes.func
    value: React.PropTypes.bool

  render: ->

    div id: @props.id, className: 'field-set comp-trigger',
      div className: 'field',
        label {},
          input
            className: 'trigger'
            type: 'checkbox'
            checked: @props.value
            onChange: @props.callback
          span {}
