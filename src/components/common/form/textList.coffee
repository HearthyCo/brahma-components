React = require 'react'
_ = require 'underscore'

ReactIntl = require '../../../mixins/ReactIntl'

InputMultiline = React.createFactory require './inputMultiline'

{ div, span, input, button } = React.DOM

module.exports = React.createClass

  displayName: 'text'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    valueLink: React.PropTypes.object.isRequired

  handleRemove: (i) -> =>
    newValue = @props.valueLink.value
    newValue.splice i, 1
    @props.valueLink.requestChange newValue

  handleAdd: (e) ->
    e?.preventDefault()
    value = @refs.input.getValue()
    if value
      newValue = @props.valueLink.value
      newValue.push value
      @props.valueLink.requestChange newValue
    # Clear input
    @refs.input.setValue ""
    return

  render: ->
    className = 'comp-textList'

    div className: className, id: @props.id,
      div className: 'entries',
        for entry, i in @props.valueLink.value
          div key: i,
            span className: 'textEntry', entry
            span className: 'remove', onClick: @handleRemove(i),
              @getIntlMessage 'remove'

      div className: 'new-entry',
        InputMultiline
          ref: 'input'
          placeholder: @getIntlMessage 'write-here'
          onEnter: @handleAdd
        button onClick: @handleAdd,
          @getIntlMessage 'add'