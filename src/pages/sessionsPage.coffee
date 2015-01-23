React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

SessionsStore = require '../stores/SessionsStore'

SessionsActions = require '../actions/SessionsActions'

TimelineEntry = React.createFactory(
  require '../components/session/timelineEntry'
)

{ div } = React.DOM

module.exports = React.createClass

  displayName: 'sessionsPage'

  mixins: [ReactIntl]

  propTypes:
    state: React.PropTypes.string.isRequired

  getInitialState: ->
    sessions: SessionsStore[@props.state].getAll()

  componentDidMount: ->
    SessionsStore.addChangeListener @updateState
    SessionsActions.refresh @props.state

  componentWillUnmount: ->
    SessionsStore.removeChangeListener @updateState

  componentWillReceiveProps: (next) ->
    if @props.state isnt next.state
      SessionsActions.refresh next.state

  updateState: () ->
    @setState { sessions: SessionsStore[@props.state].getAll() }

  render: ->
    sessions = @state.sessions.map (session) ->
      TimelineEntry key: session.id, session: session

    div className: 'page-sessions page-sessions-' + @props.state,
      sessions