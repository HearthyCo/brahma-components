React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

SessionsStore = require '../stores/SessionsStore'

#SessionsActions = require '../actions/SessionsActions'

TimelineEntry = React.createFactory require '../components/session/timelineEntry'

{ div } = React.DOM

module.exports = React.createClass

  mixins: [ReactIntl]

  getInitialState: ->
    sessions: SessionsStore[@props.state]

  componentDidMount: ->
    SessionsStore.addChangeListener @updateState
    #SessionsActions.refresh @props.state

  componentWillUnmount: ->
    SessionsStore.removeChangeListener @updateState

  updateState: () ->
    @setState { sessions: SessionsStore[@props.state] }

  render: ->
    #sessionsLabel = @getIntlMessage('sessions')
    sessions = @state.sessions.map (session) ->
      TimelineEntry key: session.id, session: session

    div className: 'page-sessions page-sessions-' + @props.state,
      sessions