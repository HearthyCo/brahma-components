React = require 'react'
ReactIntl = require 'react-intl'

{ div, img, span, a } = React.DOM

clock = 'https://cdn0.iconfinder.com/data/icons/feather/96/clock-32.png'

module.exports = React.createClass

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    session: React.PropTypes.object.isRequired


  render: ->
    div id: @props.id, className: 'comp-sessionentry',
      div className: 'session-label',
        span className: 'date',
          @formatDate @props.session.get('startDate'), 'dateonly'
        span className: 'time',
          span className: 'icon icon-clock'
          @formatTime @props.session.get('startDate'), 'time'
        span className: 'session-title', @props.session.get('title')
      a className: 'session-link', href: '/session/' + @props.session.get('id'),
        @getIntlMessage('access')