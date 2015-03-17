React = require 'react'
ReactIntl = require 'react-intl'

SessionActions = require '../../actions/SessionActions'
ListStores = require '../../stores/ListStores'

{ div, h2, span, button, ul, li, a } = React.DOM

#SessionEntry = React.createFactory require './sessionEntry'

module.exports = React.createClass

  displayName: 'sessionTypeTab'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    sessionType: React.PropTypes.object.isRequired
    sessions: React.PropTypes.array.isRequired

  contextTypes:
    opts: React.PropTypes.object

  render: ->
    _this = @

    assign = -> SessionActions.assign _this.props.sessionType.id

    div id: @props.id, className: 'comp-sessionTypeTab',
      h2 {}, @props.sessionType.name
      div className: 'sessiontype-queue',
        div className: 'queue-status',
          span className: 'queue-length', @props.sessionType.waiting
          span className: 'queue-label', ' ' + @getIntlMessage('waiting')
        button className: 'queue-assign', onClick: assign,
          @getIntlMessage('add')
      ul className: 'sessiontype-sessions',
        @props.sessions.map (s) ->
          timerclasses = 'session-timer '

          timerclasses += 'notifications'
          messageCounter = ListStores.Session.LastViewedMessage.getCounter s.id
          notification = messageCounter

          if s.id.toString() is _this.context.opts.sessionId
            rowclasses = 'current'

          li key: s.id, className: rowclasses,
            a className: 'session-title', href: '/session/' + s.id, s.title

            if notification
              span className: timerclasses, notification