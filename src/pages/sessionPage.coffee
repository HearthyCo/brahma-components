React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

SessionStore = require '../stores/SessionStore'

SessionActions = require '../actions/SessionActions'

#SessionActions = require '../actions/SessionActions'

ProfessionalBrief = React.createFactory(
  require '../components/user/professionalBrief'
)
IconButton = React.createFactory require '../components/common/iconbutton'
Datetime = React.createFactory require '../components/common/datetime'

{ div, p } = React.DOM

module.exports = React.createClass

  displayName: 'sessionPage'
  statics: sectionName: 'sessionSection'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string.isRequired

  getInitialState: ->
    session: SessionStore.get @props.id

  componentDidMount: ->
    SessionStore.addChangeListener @updateState
    SessionActions.refresh @props.id

  componentWillUnmount: ->
    SessionStore.removeChangeListener @updateState

  componentWillReceiveProps: (next) ->
    if @props.id isnt next.id
      SessionActions.refresh next.id

  updateState: () ->
    @setState session: SessionStore.get @props.id

  render: ->
    profs = []
    if @state.session and @state.session.users.professionals
      sessionDate = p {},
        Datetime value: @state.session.startDate

      profs = @state.session.users.professionals.map (user) ->
        ProfessionalBrief user: user, key: user.id, sessionDate

    attach = @getIntlMessage 'check-attachments'
    treatm = @getIntlMessage 'check-treatment'

    div className: 'page-session',
      profs
      # TODO: Show elements specific to session state
      IconButton icon: 'clip', label: attach, url: '/'
      IconButton icon: 'pill', label: treatm, url: '/'