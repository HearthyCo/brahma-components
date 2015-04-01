React = require 'react/addons'

AlertActions = require '../../actions/AlertActions'

{ span, div } = React.DOM

module.exports = React.createClass

  displayName: 'alert'

  propTypes:
    alertsIdx: React.PropTypes.array
    alerts: React.PropTypes.object
    visible: React.PropTypes.bool

  getDefaultProps: ->
    alertsIdx: []
    alerts:    {}
    visible:   false

  handleCloseClick: (e) ->
    if @props.onClose
      @props.onClose()
    else
      AlertActions.close()

  render: ->
    _classname = "comp-alert"
    _classname += if @props.visible then " visible" else " hidden"

    div className: _classname,
      div className: 'alert-close', onClick: @handleCloseClick,
        span className: 'icon icon-cross'
      div className: 'alerts',
        @props.alertsIdx.map (id, i) =>
          # console.log 'Alert ID', id
          alert = @props.alerts[id]
          if alert.content
            alert.onDone.call alert if alert.onDone
            div key: "alert-#{id}", className: "alert level-#{alert.level}",
              span {}, alert.content
