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
    _this = @

    assign: -> SessionActions.assign sessionType

    div id: @props.id, className: 'comp-sessionTypeTab',
      h2 {}, @props.sessionType.name
      div className: 'sessiontype-queue',
        div className: 'queue-status',
          span className: 'queue-length', @props.sessionType.poolsize
          span className: 'queue-label', ' ' + @getIntlMessage('waiting')
        button className: 'queue-assign', onClick: assign,
          @getIntlMessage('add')
      ul className: 'sessiontype-sessions',
        @props.sessions.map (s) ->
          timerclasses = 'session-timer '
          if s.id is 90704 # Fake
            timerclasses += 'good'
            value = '04:03'
          else if s.id is 90700 # Fake
            timerclasses += 'bad'
            value = '04:03'
          else
            timerclasses += 'notifications' # Fake
            value = '4'
          if s.id is 90704 and _this.props.sessionType.id is 90300
            rowclasses = 'current'
          li key: s.id, className: rowclasses,
            span className: 'session-title', s.title
            span className: timerclasses, value