React = require 'react'
ReactIntl = require 'react-intl'

{ div, img, span, a } = React.DOM

module.exports = React.createClass

  displayName: 'timelineentry'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    session: React.PropTypes.object.isRequired

  render: ->
    url = '/session/' + @props.session.id
    div className: 'wrapper',
      div id: @props.id, className: 'comp-timelineentry',
        div className: 'session-wrapper',
          div className: 'session-head',
            span className: 'date',
              @formatDate @props.session.startDate, 'datetime'
            span className: 'separator', ' - '
            span className: 'session-title', @props.session.title
          div className: 'session-body',
            @getIntlMessage('professional')
            # TODO: Nombre y apellidos
          div className: 'session-foot',
            a className: 'session-link', href: url,
              @getIntlMessage('view-session')
