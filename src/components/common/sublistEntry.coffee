React = require 'react'

{ div, span } = React.DOM

module.exports = React.createClass

  displayName: 'sublistentry'

  propTypes:
    id: React.PropTypes.number
    label: React.PropTypes.string.isRequired
    sublabel: React.PropTypes.string.isRequired

  getInitialState: () ->
    isExpanded: false

  toggleDisplay: ->
    @setState isExpanded: not @state.isExpanded

  render: ->
    contentClasses = 'entry-content'
    if @state.isExpanded
      contentClasses += ' is-expanded'

    div id: @props.id, className: 'comp-sublistentry',
      div className: 'entry-button', onClick: @toggleDisplay,
        span className: 'label',
          @props.label
        span className: 'label',
          @props.sublabel
        span className: 'icon icon-left'
      div className: contentClasses,
        @props.children