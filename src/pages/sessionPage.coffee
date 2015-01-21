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

{ div } = React.DOM

module.exports = React.createClass

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
    if @state.session and @state.session.professionals
      profs = @state.session.professionals.map (user) ->
        ProfessionalBrief user: user, key: user.id
    attach = @getIntlMessage 'check-attachments'
    treatm = @getIntlMessage 'check-treatment'

    div className: 'page-session',
      profs
      # TODO: Show elements specific to session state
      IconButton icon: 'clock', label: attach, url: '/'
      IconButton icon: 'home', label: treatm, url: '/'