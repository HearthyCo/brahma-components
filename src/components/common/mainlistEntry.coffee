React = require 'react'

{ div, span } = React.DOM

IconBadge = React.createFactory require './iconbadge'
PageActions = require '../../actions/PageActions'

FrontendUtils = require '../../util/frontendUtils'

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
    {}

  ###
    If @props.target is defined then navigate to it. Otherwise
    just toggle the element content visibility.
  ###
  toggleDisplay: ->
    if @props.target
      PageActions.navigate @props.target
    else
      if not @state.isExpanded
        FrontendUtils.scrollAnimated @refs.element.getDOMNode()
      @setState isExpanded: not @state.isExpanded

  render: ->
    contentClasses = 'comp-mainlistentry'
    if @state.isExpanded
      contentClasses += ' is-expanded'

    else if @state.isExpanded is false
      contentClasses += ' is-collapsed'

    div id: @props.id, className: contentClasses, ref: 'element',
      div className: 'entry-button', onClick: @toggleDisplay,
        span className: 'label',
          @props.label
        @props.extra
        IconBadge icon: @props.icon, value: @props.value
      div className: 'entry-content',
        @props.children