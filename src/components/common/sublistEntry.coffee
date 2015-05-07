React = require 'react'

PageActions = require '../../actions/PageActions'

FrontendUtils = require '../../util/frontendUtils'

{ div, span, h2, p } = React.DOM

module.exports = React.createClass

  displayName: 'sublistentry'

  propTypes:
    id: React.PropTypes.number
    label: React.PropTypes.string.isRequired
    icon: React.PropTypes.string
    sublabel: React.PropTypes.string
    target: React.PropTypes.string
    onClick: React.PropTypes.func
    defaultOpen: React.PropTypes.bool
    scrollAnimated: React.PropTypes.bool

  getDefaultProps: ->
    defaultOpen: false
    scrollAnimated: true

  getInitialState: (props) ->
    props = props or @props
    isExpanded: props.defaultOpen or null

  componentWillReceiveProps: (next) ->
    if @props.defaultOpen isnt next.defaultOpen
      @setState @getInitialState next

  toggleDisplay: ->
    if @props.rel isnt 'disabled'
      if @props.target
        PageActions.navigate @props.target
      else if @props.onClick
        @props.onClick.call @
      else
        if @props.scrollAnimated and not @state.isExpanded
          offset = if process.env.HEARTHY_APP isnt 'web' then 0 else 80
          FrontendUtils.scrollAnimated @refs.element.getDOMNode(), offset
        @setState isExpanded: not @state.isExpanded

  render: ->
    if @props.icon
      contentClasses = 'comp-iconsublistentry'
    else
      contentClasses = 'comp-sublistentry'

    if @state.isExpanded
      contentClasses += ' is-expanded'
    else if @state.isExpanded is false
      contentClasses += ' is-collapsed'

    div id: @props.id, className: contentClasses, ref: 'element',
      div className: 'entry-button', onClick: @toggleDisplay,
        div className: 'label',
          if @props.icon
            div className: 'icon icon-' + @props.icon
          h2 {},
            span className: 'date',
              @props.time
            @props.label
          if @props.sublabel
            p {},
              @props.sublabel
        span className: 'icon icon-right'
      div className: 'entry-content',
        @props.children