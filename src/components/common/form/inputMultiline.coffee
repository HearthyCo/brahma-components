React = require 'react'
_ = require 'underscore'

{ textarea } = React.DOM

module.exports = React.createClass

  displayName: 'inputMultiline'

  lastScrollHeight: 0

  propTypes:
    rowsMax: React.PropTypes.number
    rowsMin: React.PropTypes.number
    valueLink: React.PropTypes.object
    onEnter: React.PropTypes.func
    onKeyPress: React.PropTypes.func

  componentDidMount: ->
    input = @refs.input.getDOMNode()
    if input
      @lastScrollHeight = input.scrollHeight

  getDefaultProps: ->
    rowsMax: 5
    rowsMin: 1

  getValue: -> @refs.input.getDOMNode().value.trim()
  setValue: (newValue) ->
    newValue = newValue.trim()
    inputDOM = @refs.input.getDOMNode()
    inputDOM.value = newValue
    @resizeInput inputDOM

  handleKeyPress: (e) ->
    input = @refs.input
    inputDOM = e.target
    # If the user has pressed enter
    if e.key is "Enter"
      e.preventDefault()
      @props.onEnter?.call @, e
      @setValue ""
    else
      @resizeInput inputDOM
      # Extendable event
      @props.onKeyPress?.call @, e

  resizeInput: (inputDOM) ->
    rows = parseInt inputDOM.getAttribute "rows"
    # If we don't decrease the amount of rows,
    # the scrollHeight would show the scrollHeight for
    # all the rows, even if there is no text.
    inputDOM.setAttribute "rows", @props.rowsMin
    if inputDOM.value
      if rows < @props.rowsMax and inputDOM.scrollHeight > @lastScrollHeight
        ++rows
      else
        if rows > @props.rowsMin and inputDOM.scrollHeight < @lastScrollHeight
          --rows
      inputDOM.setAttribute "rows", rows
    @lastScrollHeight = inputDOM.scrollHeight

  render: ->
    className = (@props.className or "") + " inputMultiline"
    props = _.extend { rows: @props.rowsMin }, @props,
      onKeyPress: @handleKeyPress
      ref: 'input', className: className

    textarea props
