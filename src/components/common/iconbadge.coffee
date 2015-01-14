React = require 'react'

{ div, img, span } = React.DOM

module.exports = React.createClass

  propTypes:
    id: React.PropTypes.string
    value: React.PropTypes.number
    icon: React.PropTypes.string.isRequired

  getDefaultProps: ->
    value: 0

  render: ->
    div id: @props.id, className: 'comp-iconbadge',
      if @props.value then span className: 'badge',
        @props.value
      img className: 'icon', src: @props.icon