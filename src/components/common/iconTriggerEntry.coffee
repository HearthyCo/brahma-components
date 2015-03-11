React = require 'react'

{ div, span, h2 } = React.DOM

PageActions = require '../../actions/PageActions'
Trigger = React.createFactory require '../common/form/trigger'

module.exports = React.createClass

  displayName: 'iconTriggerEntry'

  propTypes:
    id: React.PropTypes.number
    label: React.PropTypes.string.isRequired
    icon: React.PropTypes.string.isRequired
    target: React.PropTypes.string
    time: React.PropTypes.object.isRequired
    trigger: React.PropTypes.bool

  handleClick: ->
    PageActions.navigate @props.target

  render: ->

    div id: @props.id, className: 'comp-iconTriggerEntry',
      div className: 'entry',
        div className: 'label', onClick: @handleClick,
          div className: 'icon icon-' + @props.icon
          h2 {},
            span className: 'date',
              @props.time
            @props.label
        if @props.trigger
          span className: 'trigger',
            Trigger {}
