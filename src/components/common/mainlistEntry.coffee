React = require 'react'

{ div, span } = React.DOM

IconBadge = React.createFactory require './iconbadge'

module.exports = React.createClass

  displayName: 'mainlistentry'

  propTypes:
    id: React.PropTypes.string
    label: React.PropTypes.string.isRequired
    icon: React.PropTypes.string.isRequired
    value: React.PropTypes.number
    extra: React.PropTypes.node
    target: React.PropTypes.string

  getInitialState: () ->
    return {isExpanded: false}

  toggleDisplay: ->
    if @props.target
      window.routerNavigate @props.target
    else
      @setState isExpanded: not @state.isExpanded

  render: ->
    contentClasses = 'entry-content'
    if @state.isExpanded
      contentClasses += ' is-expanded'

    div id: @props.id, className: 'comp-mainlistentry',
      div className: 'entry-button', onClick: @toggleDisplay,
        span className: 'label',
          @props.label
        @props.extra
        IconBadge icon: @props.icon, value: @props.value
      div className: contentClasses,
        @props.children