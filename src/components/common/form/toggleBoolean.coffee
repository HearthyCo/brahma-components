React = require 'react/addons'
_ = require 'underscore'

{ div, label, span, input } = React.DOM

module.exports = React.createClass

  displayName: 'toggleBoolean'

  mixins: [React.addons.LinkedStateMixin]

  contextTypes:
    editable: React.PropTypes.bool

  render: ->
    props = _.omit(@props, 'id', 'label')
    props.type = 'checkbox'

    if @context.editable
      props.disabled = props.noedit or false
    else
      props.disabled = true

    child = input props

    div className:'comp-toggleSelect',
      div className: 'label',
        label {}, @props.label
      div className: 'field', child
