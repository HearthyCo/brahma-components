React = require 'react'

{ div, span, a } = React.DOM

module.exports = React.createClass

  displayName: 'breadcrumb'

  propTypes:
    list: React.PropTypes.array.isRequired

  render: ->
    if(@props.list.length > 0)
      crumbs = @props.list
      home = { label: 'Home', link: '/', className: 'crumb icon icon-home' }
      crumbs.unshift home

      div id: @props.id, className: 'comp-breadcrumb',
        crumbs.map (crumb, i) ->
          div key: i, className: crumb.className,
            a href: crumb.link,
              crumb.label