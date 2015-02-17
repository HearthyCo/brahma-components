React = require 'react'

{ div, span, h2, p } = React.DOM

module.exports = React.createClass

  displayName: 'withSidebar'

  propTypes:
    id: React.PropTypes.number
    sidebar: React.PropTypes.node.isRequired

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
      span className: 'toggle-button icon icon-right', onClick: @toggleDisplay
      div className: 'content', @props.children
      div className: 'side-wrapper',
        div className: 'side-content', @props.sidebar