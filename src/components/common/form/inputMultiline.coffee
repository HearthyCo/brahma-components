React = require 'react'
_ = require 'underscore'

{ textarea } = React.DOM

module.exports = React.createClass

  displayName: 'inputMultiline'

  lastScrollHeight: 0

  propTypes:
    rowsLimit: React.PropTypes.integer

  componentDidMount: ->
    input = @refs.input.getDOMNode()
    if input
      @lastScrollHeight = input.scrollHeight

  getDefaultProps: ->
    rowsLimit: 5

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
      if @props.onEnter
        @props.onEnter.call @, e
      else
        # Prevent HTML5 behaviuor detecting an id (string)
        if inputDOM.form and "string" isnt typeof inputDOM.form
          # This should submit but it does not :(
          inputDOM.form.submit() if inputDOM.form.submit

      @setValue ""
    else
      @resizeInput inputDOM
      # Extendable event
      if @props.onKeyPress
        @props.onKeyPress.call @, e

  resizeInput: (inputDOM) ->
    rows = parseInt inputDOM.getAttribute "rows"
    # If we don't decrease the amount of rows,
    # the scrollHeight would show the scrollHeight for
    # all the rows, even if there is no text.
    inputDOM.setAttribute "rows", "1"
    if inputDOM.value
      if rows < @props.rowsLimit and inputDOM.scrollHeight > @lastScrollHeight
        ++rows
      else if rows > 1 and inputDOM.scrollHeight < @lastScrollHeight
        --rows
      inputDOM.setAttribute "rows", rows
    @lastScrollHeight = inputDOM.scrollHeight


  render: ->
    className = (@props.className or "") + " inputMultiline"
    props = _.extend { rows: 1 }, @props,
      onKeyPress: @handleKeyPress
      ref: 'input', className: className
    textarea props
