React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

EntityStores = require '../../stores/EntityStores'
ListStores = require '../../stores/ListStores'
HistoryActions = require '../../actions/HistoryActions'

AllergyEntry = React.createFactory require '../history/allergyEntry'
IconSubListEntry = React.createFactory require '../common/iconSublistEntry'
HistoriesEntry = React.createFactory require '../history/historiesEntry'

{ div, span, strong, a, br, h2, img } = React.DOM

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
      user: EntityStores.User.get @props.user?.id
    @setState ret
    ret

  render: ->

    avatar = @props.user.avatar || '/res/images/default-avatar.png'
    _this = @
    user = EntityStores.User.get @props.user.id
    fullname = ['name', 'surname1', 'surname2']
      .map (f) -> user[f]
      .filter (v) -> v
      .join ' '


    profileData = @state.user
    if profileData
      profile =
        div className: 'userbrief',
          img className: 'avatar', src: avatar
          div className: 'profile',
            div className: 'name', fullname
            a className: 'view-profile', href: '#', @getIntlMessage 'view-more'
    else
      profile = div {}

    allergies = @state.allergies.map (allergy) ->
      AllergyEntry key: allergy.id, allergy: allergy


    div className: 'comp-sidebarUserProfile',
      h2 className: 'sideBar-section', @getIntlMessage 'history'
      profile
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
      IconSubListEntry label: 'Enfermería', icon: 'allergy',
        HistoriesEntry {}
        a className: 'view-more', href: '/history',
          @getIntlMessage 'view-more'
