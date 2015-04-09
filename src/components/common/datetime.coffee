React = require 'react'
ReactIntl = require '../../mixins/ReactIntl'

{ span } = React.DOM

module.exports = React.createClass

  displayName: 'datetime'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    value: React.PropTypes.number.isRequired

  render: ->
    span id: @props.id, className: 'comp-datetime',
      span className: 'date',
        @formatDate @props.value, 'dateonly'
      span className: 'time',
        span className: 'icon icon-clock'
        @formatTime @props.value, 'time'