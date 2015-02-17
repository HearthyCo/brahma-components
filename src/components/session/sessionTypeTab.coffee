React = require 'react'
ReactIntl = require 'react-intl'

{ div, h2, span, button, ul, li } = React.DOM

#SessionEntry = React.createFactory require './sessionEntry'

module.exports = React.createClass

  displayName: 'sessionTypeTab'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    sessionType: React.PropTypes.object.isRequired
    sessions: React.PropTypes.array.isRequired

  render: ->
    div id: @props.id, className: 'comp-sessionTypeTab',
      h2 {}, @props.sessionType.name
      div className: 'sessiontype-queue',
        div className: 'queue-status',
          span className: 'queue-length', @props.sessionType.poolsize
          span className: 'queue-label', ' ' + @getIntlMessage('waiting')
        button className: 'queue-assign', @getIntlMessage('add')
      ul className: 'sessiontype-sessions',
        @props.sessions.map (s) ->
          timerclasses = 'session-timer '
          if s.id is 90704 # Fake
            timerclasses += 'good'
          else
            timerclasses += 'bad'
          li {},
            span className: 'session-title', s.title
            span className: timerclasses, '04:03' # Fake
