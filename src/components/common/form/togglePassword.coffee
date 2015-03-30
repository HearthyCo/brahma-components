React = require 'react'
_ = require 'underscore'

{ div, label, input, span } = React.DOM

module.exports = React.createClass

  displayName: 'toggleInput'

  statics: linkType: 'value'

  contextTypes:
    editable: React.PropTypes.bool

  stateTypes:
    showPass: React.PropTypes.bool

  getInitialState: ->
    showPass: true

  changeShowPass: (evt) ->
    @setState showPass: evt.target.checked or false

  render: ->
    props = _.omit(@props, 'id', 'label')
    if @state.showPass
      props.type = 'text'
    else
      props.type = 'password'

    if @context.editable
      child = [
        input props
        input
          className: 'showPass'
          type: 'checkbox'
          onChange: @changeShowPass
          checked: @state.showPass
      ]
    else
      child = span {}, '**************'

    div className:'comp-toggleInput comp-togglePassword',
      div className: 'label',
        label {}, @props.label
      div className: 'field',
        child
