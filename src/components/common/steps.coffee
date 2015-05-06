React = require 'react/addons'
_ = require 'underscore'

{ div, img, span, a } = React.DOM

module.exports = React.createClass

  displayName: 'steps'

  propTypes:
    # Mandatory settings:
    total: React.PropTypes.number.isRequired
    valueLink: React.PropTypes.object.isRequired
    # Optional settings:
    id: React.PropTypes.string
    noCancel: React.PropTypes.bool # Hide prev arrow on first step
    noComplete: React.PropTypes.bool # Hide next arrow on last step
    # Callbacks:
    onNext: React.PropTypes.func
    onPrev: React.PropTypes.func
    onCancel: React.PropTypes.func # Back clicked on first step
    onComplete: React.PropTypes.func # Next clicked on last step

  # To inhibit the step change from onNext or onPrev callback, return false.

  handlePrev: ->
    if @props.valueLink.value > 1
      step = @props.valueLink.value - 1
      r = @props.onPrev? step
      @props.valueLink.requestChange step if r isnt false
    else if @props.valueLink.value = 1
      @props.onCancel?()

  handleNext: ->
    if @props.valueLink.value < @props.total
      step = @props.valueLink.value + 1
      r = @props.onNext? step
      @props.valueLink.requestChange step if r isnt false
    else if @props.valueLink.value = @props.total
      @props.onComplete?()

  render: ->
    prev = span className: 'icon icon-arrow-left', onClick: @handlePrev
    next = span className: 'icon icon-arrow-right', onClick: @handleNext
    div className: 'comp-steps', id: @props.id,
      prev unless @props.valueLink.value is 1 and @props.noCancel
      div className: 'progress',
        for i in [1..@props.total]
          className = 'step'
          className += ' active' if @props.valueLink.value is i
          div key: i, className: className, i + '/' + @props.total
      next unless @props.valueLink.value is @props.total and @props.noComplete
