React = require 'react'

{ div, span, h2, p } = React.DOM

module.exports = React.createClass

  displayName: 'withSidebar'

  propTypes:
    id: React.PropTypes.number
    sidebar: React.PropTypes.node.isRequired
    icons: React.PropTypes.node

  getInitialState: () ->
    {}

  toggleDisplay: ->
    @setState isExpanded: not @state.isExpanded

  render: ->
    contentClasses = 'comp-withsidebar'
    if @state.isExpanded
      contentClasses += ' is-expanded'
    else if @state.isExpanded is false
      contentClasses += ' is-collapsed'

    div id: @props.id, className: contentClasses,
      div className: 'content', @props.children
      div className: 'side-wrapper',
        div className: 'side-header', @props.icons
        div className: 'side-content', @props.sidebar
      div className: 'toogle',
        span className: 'icon icon-question'
        span className: 'toggle-button icon icon-right', onClick: @toggleDisplay