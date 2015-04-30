React = require 'react'
ReactIntl = require '../../mixins/ReactIntl'

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

  getInitialState: ->
    @update()

  componentDidMount: ->
    ListStores.Session.LastViewedMessage.addChangeListener @update
    ListStores.Session.Messages.addChangeListener @update

  componentWillUnmount: ->
    ListStores.Session.LastViewedMessage.removeChangeListener @update
    ListStores.Session.Messages.removeChangeListener @update

  update: ->
    counters = {}
    @props.sessions.map (s) ->
      counters[s.id] = ListStores.Session.LastViewedMessage.getCounter s.id
    state = counters: counters
    @setState state if @isMounted()
    state

  handleAssign: -> SessionActions.assign @props.sessionType.id

  render: ->
    _this = @

    div id: @props.id, className: 'comp-sessionTypeTab',
      h2 {}, @props.sessionType.name
      div className: 'sessiontype-queue',
        div className: 'queue-status',
          span className: 'queue-length', @props.sessionType.waiting
          span className: 'queue-label', ' ' + @getIntlMessage('waiting')
        button className: 'queue-assign', onClick: @handleAssign,
          @getIntlMessage('add')
      ul className: 'sessiontype-sessions',
        @props.sessions.map (s) ->
          timerclasses = 'session-timer '

          timerclasses += 'notifications'
          messageCounter = _this.state.counters?[s.id]
          notification = messageCounter

          if s.id.toString() is _this.context.opts.sessionId
            rowclasses = 'current'

          li key: s.id, className: rowclasses,
            a className: 'session-title', href: '/session/' + s.id, s.title

            if notification
              span className: timerclasses, notification