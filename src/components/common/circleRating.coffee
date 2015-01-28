React = require 'react'

{ div, span } = React.DOM

module.exports = React.createClass

  displayName: 'circleRating'

  propTypes:
    id: React.PropTypes.string
    value: React.PropTypes.number
    maxValue: React.PropTypes.number

  getDefaultProps: ->
    value: 1
    maxValue: 5

  render: ->
    spans = for n in [1..@props.maxValue]
      classes = 'circle-' + n
      if n <= @props.value
        classes += ' circle-filled'
      span key: n, className: classes

    div id: @props.id, className: 'comp-circlerating', spans

