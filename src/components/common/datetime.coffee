React = require 'react'
ReactIntl = require 'react-intl'

{ span } = React.DOM

module.exports = React.createClass

  displayName: 'datetime'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    value: React.PropTypes.object.isRequired

  render: ->
    span id: @props.id, className: 'comp-datetime',
      span className: 'date',
        @formatDate @props.value, 'dateonly'
      span className: 'time',
        span className: 'icon icon-reloj'
        @formatTime @props.value, 'time'