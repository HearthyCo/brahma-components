React = require 'react/addons'
ReactIntl = require '../../mixins/ReactIntl'
_ = require 'underscore'
Utils = require '../../util/frontendUtils'

EntityStores = require '../../stores/EntityStores'
ListStores = require '../../stores/ListStores'

AllergyEntry = React.createFactory require '../history/allergyEntry'
IconSubListEntry = React.createFactory require '../common/iconSublistEntry'
HistoriesEntry = React.createFactory require '../history/historiesEntry'

{ div, span, strong, a, br, h2, img } = React.DOM

module.exports = React.createClass

  displayName: 'sidebarUserProfile'

  mixins: [ReactIntl]

  propTypes:
    user: React.PropTypes.object.isRequired
    session: React.PropTypes.object


  getInitialState: ->
    @updateState()

  componentDidMount: ->
    EntityStores.HistoryEntry.addChangeListener @updateState
    EntityStores.User.addChangeListener @updateState
    ListStores.User.History.addChangeListener @updateState

  componentWillUnmount: ->
    EntityStores.HistoryEntry.removeChangeListener @updateState
    EntityStores.User.removeChangeListener @updateState
    ListStores.User.History.removeChangeListener @updateState

  updateState: () ->
    ret =
      history: ListStores.User.History.getObjects @props.user?.id
      user: EntityStores.User.get @props.user?.id
    _.defaults ret, history: []
    @setState ret if @isMounted()
    ret

  render: ->

    avatar = @props.user.avatar or '/res/images/default-avatar.png'
    _this = @
    user = EntityStores.User.get @props.user.id
    fullname = Utils.fullName user

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

    allergies = @state.history
      .filter (he) -> he.type is 'allergies'
      .map (allergy) ->
        AllergyEntry key: allergy.id, allergy: allergy

    # Simple history (covered before the session)
    history = @state.user?.meta?.history or {}
    historyBox = (label, icon, section) =>
      if section?.length
        IconSubListEntry label: @getIntlMessage(label), icon: icon,
          div className: 'comp-historiesentry',
            section.map (e, i) ->
              div className: 'entry', key: i,
                e


    div className: 'comp-sidebarUserProfile',
      h2 className: 'sideBar-section', @getIntlMessage 'history'
      profile
      # IconSubListEntry label: 'Alergias', icon: 'allergy',
      #   allergies
      # IconSubListEntry
      #   label: 'Vacunas'
      #   icon: 'vaccine'
      #   target: '/allergies'
      #   rel: 'disabled'
      # IconSubListEntry label: 'Tratamientos', icon: 'pill',
      #   HistoriesEntry {}
      #   HistoriesEntry {}
      #   a className: 'view-more', href: '/history', rel: 'disabled',
      #     @getIntlMessage 'view-more'
      # IconSubListEntry label: 'Problemas resueltos', icon: 'problem-2',
      #   HistoriesEntry {}
      #   a className: 'view-more', href: '/history', rel: 'disabled',
      #     @getIntlMessage 'view-more'
      # IconSubListEntry label: 'Problemas actuales', icon: 'problem',
      #   HistoriesEntry {}
      #   a className: 'view-more', href: '/history', rel: 'disabled',
      #     @getIntlMessage 'view-more'
      # IconSubListEntry label: 'Enfermería', icon: 'nursing',
      #   HistoriesEntry {}
      #   a className: 'view-more', href: '/history', rel: 'disabled',
      #     @getIntlMessage 'view-more'
      IconSubListEntry label: @getIntlMessage('reason'), icon: 'nursing',
        div className: 'comp-historiesentry',
          div className: 'entry',
            @props.session?.meta?.reason

      historyBox 'allergies', 'allergy', history.allergies
      historyBox 'conditions', 'problem', history.conditions
      historyBox 'treatments', 'pill', history.treatments
