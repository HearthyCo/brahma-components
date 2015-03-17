React = require 'react'
ReactIntl = require 'react-intl'

{ div, img, span, a } = React.DOM

Datetime = React.createFactory require '../common/datetime'
ListStores = require '../../stores/ListStores'

module.exports = React.createClass

  displayName: 'sessionentry'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    session: React.PropTypes.object.isRequired

  render: ->
    sessionId = @props.session.id

    div id: @props.id, className: 'comp-sessionentry',
      a className: 'session-link', href: '/session/' + @props.session.id,
        div className: 'session-label',
          Datetime value: @props.session.startDate
          span className: 'session-title', @props.session.title
        div className: 'session-notify',
          if ListStores.Session.LastViewedMessage.getCounter(sessionId) > 0
            span className: 'icon icon-advice'