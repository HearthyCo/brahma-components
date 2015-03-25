React = require 'react/addons'

AlertActions = require '../../actions/AlertActions'

{ span, div } = React.DOM

module.exports = React.createClass

  displayName: 'alert'

  propTypes:
    level: React.PropTypes.string
    message: React.PropTypes.string

  handleCloseClick: (e) ->
    if @props.onClose
      @props.onClose()
    else
      AlertActions.close()

  render: ->
    # TODO: alert loop render

    _classname = "comp-alert"
    _classname += " level-#{@props.level}" if @props.level

    div className: _classname,
      div className: 'alert-close', onClick: @handleCloseClick,
        span className: 'icon icon-cross'
      div className: 'message',
        @props.content
