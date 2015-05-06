React = require 'react'
_ = require 'underscore'

ReactIntl = require '../../../mixins/ReactIntl'

{ div, span, input, textarea, button } = React.DOM

module.exports = React.createClass

  displayName: 'text'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    valueLink: React.PropTypes.object.isRequired
    multiline: React.PropTypes.bool

  getDefaultProps: ->
    multiline: false

  handleRemove: (i) -> =>
    newValue = @props.valueLink.value
    newValue.splice i, 1
    @props.valueLink.requestChange newValue

  handleAdd: (e) ->
    e.preventDefault()
    node = @refs.input.getDOMNode()
    newValue = @props.valueLink.value
    newValue.push node.value
    node.value = ''
    @props.valueLink.requestChange newValue

  render: ->
    className = 'comp-textList'
    if @props.multiline
      element = textarea
      className += ' multiline'
    else
      element = input

    div className: className, id: @props.id,
      div className: 'entries',
        for entry, i in @props.valueLink.value
          div key: i,
            span className: 'textEntry', entry
            span className: 'remove', onClick: @handleRemove(i),
              @getIntlMessage 'remove'

      div className: 'new-entry',
        element ref: 'input', placeholder: @getIntlMessage 'write-here'
        button onClick: @handleAdd,
          @getIntlMessage 'add'