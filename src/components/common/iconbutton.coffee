React = require 'react'

{ a, img, span, div } = React.DOM

module.exports = React.createClass

  displayName: 'iconbutton'

  propTypes:
    id: React.PropTypes.string
    icon: React.PropTypes.string.isRequired
    label: React.PropTypes.string.isRequired
    url: React.PropTypes.string
    onClick: React.PropTypes.func

  render: ->
    opts =
      id: @props.id
      className: 'comp-iconbutton'
      href: @props.url
      onClick: @props.onClick,

    a opts,
      span className: 'icon icon-' + @props.icon
      span className: 'button-label',
        @props.label
