React = require 'react'

PageActions = require '../../actions/PageActions'

FrontendUtils = require '../../util/frontendUtils'

{ div, span, h2, p } = React.DOM

module.exports = React.createClass

  displayName: 'sublistentry'

  propTypes:
    id: React.PropTypes.number
    label: React.PropTypes.string.isRequired
    sublabel: React.PropTypes.string
    target: React.PropTypes.string
    onClick: React.PropTypes.func
    defaultOpen: React.PropTypes.bool

  getInitialState: () ->
    isExpanded: @props.defaultOpen or undefined

  toggleDisplay: ->
    if @props.rel isnt 'disabled'
      if @props.target
        PageActions.navigate @props.target
      else if @props.onClick
        @props.onClick.call @
      else
        if not @state.isExpanded
          offset = if process.env.HEARTHY_APP isnt 'web' then 0 else 80
          FrontendUtils.scrollAnimated @refs.element.getDOMNode(), offset
        @setState isExpanded: not @state.isExpanded

  render: ->
    contentClasses = 'comp-sublistentry'
    if @state.isExpanded
      contentClasses += ' is-expanded'
    else if @state.isExpanded is false
      contentClasses += ' is-collapsed'

    div id: @props.id, className: contentClasses, ref: 'element',
      div className: 'entry-button', onClick: @toggleDisplay,
        div className: 'label',
          h2 {},
            @props.label
          p {},
            @props.sublabel
        span className: 'icon icon-right'
      div className: 'entry-content',
        @props.children