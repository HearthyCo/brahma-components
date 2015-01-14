React = require 'react'

{ div, span } = React.DOM

IconBadge = React.createFactory require './iconbadge'

module.exports = React.createClass

  propTypes:
    id: React.PropTypes.string
    label: React.PropTypes.string.isRequired
    icon: React.PropTypes.string.isRequired
    value: React.PropTypes.number

  getInitialState: () ->
    return {isExpanded: false}

  toggleDisplay: ->
    @setState isExpanded: not @state.isExpanded

  render: ->
    contentClasses = 'entry-content'
    if @state.isExpanded
      contentClasses += ' is-expanded'

    div id: @props.id, className: 'comp-mainlistentry',
      div className: 'entry-button', onClick: @toggleDisplay,
        span className: 'label',
          @props.label
        IconBadge icon: @props.icon, value: @props.value
      div className: contentClasses,
        @props.children