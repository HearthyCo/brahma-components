React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

HomeStore = require '../stores/HomeStore'

HomeActions = require '../actions/HomeActions'

MainlistEntry = React.createFactory require '../components/common/mainlistEntry'
SessionList = React.createFactory require '../components/session/sessionList'
IconButton = React.createFactory require '../components/common/iconbutton'

{ div } = React.DOM

icon = 'clock'

module.exports = React.createClass

  mixins: [ReactIntl]

  getInitialState: ->
    data: HomeStore.getAll()

  componentDidMount: ->
    HomeStore.addChangeListener @updateState
    HomeActions.refresh()

  componentWillUnmount: ->
    HomeStore.removeChangeListener @updateState

  updateState: () ->
    @setState { data: HomeStore.getAll() }

  render: ->
    sessionsLabel = @getIntlMessage('sessions')
    sessions = []
    newSessions = 0
    for key, entries of @state.data.sessions
      entries.map (s) -> if s.isNew then newSessions++
      opts =
        title: @getIntlMessage(key)
        key: key
        url: '/sessions/' + key
        sessions: entries
      sessions.push SessionList opts

    div className: 'page-home',
      MainlistEntry label: sessionsLabel, value: newSessions, icon: icon,
        sessions