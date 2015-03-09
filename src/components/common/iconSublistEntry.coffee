React = require 'react'

{ div, span, h2, p } = React.DOM

PageActions = require '../../actions/PageActions'

module.exports = React.createClass

  displayName: 'iconSublistEntry'

  propTypes:
    id: React.PropTypes.number
    label: React.PropTypes.string.isRequired
    icon: React.PropTypes.string.isRequired
    target: React.PropTypes.string
    time: React.PropTypes.object


  ###
    If @props.target is defined then navigate to it. Otherwise
    just toggle the element content visibility.
  ###

  getInitialState: () ->
    {}

  toggleDisplay: ->
    if @props.target
      PageActions.navigate @props.target
    else
      @setState isExpanded: not @state.isExpanded

  render: ->
    contentClasses = 'comp-iconsublistentry'
    if @state.isExpanded
      contentClasses += ' is-expanded'
    else if @state.isExpanded is false
      contentClasses += ' is-collapsed'

    div id: @props.id, className: contentClasses,
      div className: 'entry-button', onClick: @toggleDisplay,
        div className: 'label',
          div className: 'icon icon-' + @props.icon
          h2 {},
            span className: 'date',
              @props.time
            @props.label
        span className: 'icon icon-right'
      div className: 'entry-content',
        @props.children