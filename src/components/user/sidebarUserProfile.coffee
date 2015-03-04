React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

EntityStores = require '../../stores/EntityStores'
ListStores = require '../../stores/ListStores'
HistoryActions = require '../../actions/HistoryActions'

UserBrief = React.createFactory require './userBrief'
AllergyEntry = React.createFactory require '../history/allergyEntry'
IconSubListEntry = React.createFactory require '../common/iconSubListEntry'
HistoriesEntry = React.createFactory require '../history/historiesEntry'

{ div, span, strong, a, br } = React.DOM

module.exports = React.createClass

  displayName: 'sidebarUserProfile'

  mixins: [ReactIntl]

  propTypes:
    user: React.PropTypes.object.isRequired


  getInitialState: ->
    @updateState()

  componentDidMount: ->
    EntityStores.HistoryEntry.addChangeListener @updateState
    EntityStores.User.addChangeListener @updateState
    ListStores.History.Allergies.addChangeListener @updateState
    HistoryActions.refresh 'allergies'

  componentWillUnmount: ->
    EntityStores.HistoryEntry.removeChangeListener @updateState
    EntityStores.User.removeChangeListener @updateState
    ListStores.History.Allergies.removeChangeListener @updateState

  updateState: () ->
    ret =
      allergies: ListStores.History.Allergies.getObjects()
      user: EntityStores.User.get @props.user.id
    @setState ret
    ret

  render: ->

    profileData = @state.user
    if profileData
      profile = UserBrief user: profileData
    else
      profile = div {}

    allergies = @state.allergies.map (allergy) ->
      AllergyEntry key: allergy.id, allergy: allergy


    div className: 'comp-sidebarUserProfile',
      profile
      a className: 'view-profile', href: '/profile', @getIntlMessage 'view-more'
      IconSubListEntry label: 'Alergias', icon: 'allergy',
        allergies
      IconSubListEntry label: 'Vacunas', icon: 'vaccine', target: '/allergies'
      IconSubListEntry label: 'Problemas resueltos', icon: 'allergy',
        HistoriesEntry {}
        a className: 'view-more', href: '/history',
          @getIntlMessage 'view-more'
      IconSubListEntry label: 'Problemas actuales', icon: 'allergy',
        HistoriesEntry {}
        a className: 'view-more', href: '/history',
          @getIntlMessage 'view-more'
      IconSubListEntry label: 'Tratamientos', icon: 'pill',
        HistoriesEntry {}
        HistoriesEntry {}
        a className: 'view-more', href: '/history',
          @getIntlMessage 'view-more'
