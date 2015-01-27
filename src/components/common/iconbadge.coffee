React = require 'react'

{ div, span } = React.DOM

module.exports = React.createClass

  displayName: 'iconBadge'

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
      div className: 'icon icon-' + @props.icon