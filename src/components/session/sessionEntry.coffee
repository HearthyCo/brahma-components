React = require 'react'
ReactIntl = require '../../mixins/ReactIntl'

{ div, img, span, a } = React.DOM

Datetime = React.createFactory require '../common/datetime'
ListStores = require '../../stores/ListStores'
EntityStores = require '../../stores/EntityStores'

urlUtils = require '../../util/urlUtils'
Utils = require '../../util/frontendUtils'

module.exports = React.createClass

  displayName: 'sessionentry'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    session: React.PropTypes.object.isRequired

  getInitialState: ->
    @update()

  componentDidMount: ->
    ListStores.Session.LastViewedMessage.addChangeListener @update
    ListStores.Session.Messages.addChangeListener @update

  componentWillUnmount: ->
    ListStores.Session.LastViewedMessage.removeChangeListener @update
    ListStores.Session.Messages.removeChangeListener @update

  update: ->
    counter = ListStores.Session.LastViewedMessage.getCounter @props.session.id
    state = counter: counter
    @setState state if @isMounted()
    state

  render: ->
    sessionId = @props.session.id
    link = urlUtils.getUrl.session @props.session
    # Title should be the first known of these properties:
    # Professional name, Service type name, Session title
    title = @props.session.title
    st = EntityStores.ServiceType.get @props.session.serviceType
    title = st.name if st?.name?
    # Disabled professional name because we don't get the participants list
    # on the session list endpoint (for now)
    #profs = ListStores.Session.Participants.getProfessional @props.session.id
    #title = Utils.fullName profs[0] if profs?[0]?
    advice = ListStores.Session.hasUpdates @props.session.id


    div id: @props.id, className: 'comp-sessionentry',
      a className: 'session-link', href: link,
        div className: 'session-label',
          Datetime value: @props.session.startDate
          span className: 'session-title', title
        div className: 'session-notify',
          if advice
            span className: 'icon icon-advice'