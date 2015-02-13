React = require 'react'

{ div, span, h2, p } = React.DOM

module.exports = React.createClass

  displayName: 'sublistentry'

  propTypes:
    id: React.PropTypes.number
    label: React.PropTypes.string.isRequired
    sublabel: React.PropTypes.string.isRequired

  getInitialState: () ->
    {}

  toggleDisplay: ->
    @setState isExpanded: not @state.isExpanded

  render: ->
    contentClasses = 'comp-sublistentry'
    if @state.isExpanded
      contentClasses += ' is-expanded'
    else if @state.isExpanded is false
      contentClasses += ' is-collapsed'

    div id: @props.id, className: contentClasses,
      div className: 'entry-button', onClick: @toggleDisplay,
        div className: 'label',
          h2 {},
            @props.label
          p {},
            @props.sublabel
        span className: 'icon icon-right'
      div className: 'entry-content',
        @props.children