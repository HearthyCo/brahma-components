React = require 'react'

{ div, span, a } = React.DOM

module.exports = React.createClass

  displayName: 'breadcrumb'

  propTypes:
    list: React.PropTypes.array.isRequired

  render: ->
    div id: @props.id, className: 'comp-breadcrumb',
      @props.list.map (crumb, i) ->
        a href: crumb.link, key: i, className: 'crumb',
          span className: 'icon icon-' + crumb.className
          span className: 'label',
            crumb.label