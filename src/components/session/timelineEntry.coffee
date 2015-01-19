React = require 'react'
ReactIntl = require 'react-intl'

{ div, img, span, a } = React.DOM

module.exports = React.createClass

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    session: React.PropTypes.object.isRequired

  render: ->
    url = '/session/' + @props.session.get('id')
    div id: @props.id, className: 'comp-timelineentry',
      div className: 'session-head',
        span className: 'date',
          @formatDate @props.session.get('startDate'), 'datetime'
        span className: 'separator', ' - '
        span className: 'session-title', @props.session.get('title')
      div className: 'session-body',
        @getIntlMessage('professional')
        # TODO: Nombre y apellidos
      div className: 'session-foot',
        a className: 'session-link', href: url,
          @getIntlMessage('view-session')