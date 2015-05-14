React = require 'react'
ReactIntl = require '../../mixins/ReactIntl'

SessionActions = require '../../actions/SessionActions'
ListStores = require '../../stores/ListStores'

{ div, h2, span, button, a } = React.DOM


module.exports = React.createClass

  displayName: 'sessionTypeHome'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    icon: React.PropTypes.string
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

    div id: @props.id, className: 'comp-sessionTypeHome',
      span className: 'icon icon-' + @props.icon
      div className: 'queue',
        div className: 'queue-status',
          span {}, @getIntlMessage('currently-there-are') + ' '
          span className: 'queue-length', @props.sessionType.waiting + ' '
          span className: 'queue-type', @getIntlMessage @props.sessionType.name
          span {}, ' ' + @getIntlMessage 'waiting'
        if @props.sessionType.waiting
          div className: 'start-session',
            span {}, @getIntlMessage 'begin-session-now'
            button className: 'queue-assign', onClick: @handleAssign,
              @getIntlMessage 'start'
