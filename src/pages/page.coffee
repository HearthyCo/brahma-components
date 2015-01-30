React = require 'react'
ReactIntl = require 'react-intl'
_ = require 'underscore'

IntlStore = require '../stores/IntlStore'
UserStore = require '../stores/UserStore'

breadcrumb = React.createFactory require '../components/common/breadcrumb'
topBar = React.createFactory require '../components/common/topBar'
bottomBar = React.createFactory require '../components/common/bottomBar'

{ section, div } = React.DOM

module.exports = React.createClass

  displayName: 'page'

  mixins: [ReactIntl]

  childContextTypes:
    availableLocales: React.PropTypes.array.isRequired
    locale: React.PropTypes.string.isRequired
    messages: React.PropTypes.object.isRequired
    formats: React.PropTypes.object.isRequired
    user: React.PropTypes.object

  getInitialState: ->
    locale: IntlStore.locale
    messages: IntlStore.messages[IntlStore.locale]
    subscriptions: []

  getChildContext: ->
    availableLocales: IntlStore.availableLocales
    locale: @state.locale
    messages: @state.messages
    formats: IntlStore.formats
    user: @state.user

  componentDidMount: ->
    @updateBreadcrumb @props
    IntlStore.addChangeListener @updateLocale
    UserStore.addChangeListener @updateUser

  componentWillReceiveProps: (next) ->
    @updateBreadcrumb next

  componentWillUnmount: ->
    IntlStore.removeChangeListener @updateLocale
    UserStore.removeChangeListener @updateUser
    for subscription in subscriptions
      subscription.store.removeChangeListener subscription.handler

  updateLocale: () ->
    @setState locale: IntlStore.locale, messages: IntlStore.messages

  updateBreadcrumb: (props) ->
    subscriptions = @state.subscriptions
    for subscription in subscriptions
      subscription.store.removeChangeListener subscription.handler

    subscriptions = []

    if @state.breadcrumb? && @state.breadcrumb.stores?
      for store in @state.breadcrumb.stores
        o = {}
        o.store = store
        o.handler = -> @updateBreadcrumb props
        o.store.addChangeListener o.handler
        subscriptions.push o

    o2 = subscriptions: subscriptions
    o2.breadcrumb = if props.breadcrumb? then props.breadcrumb.call @, props else { store: [], list: [] }

    @setState o2

  updateUser: () ->
    isLogin = not @state.user and UserStore.currentUid
    isLogout = @state.user and not UserStore.currentUid
    @setState user: UserStore.get(UserStore.currentUid)
    # Auto-navigation triggered?
    if isLogin
      window.routerNavigate '/home'
    else if isLogout
      window.routerNavigate '/'

  render: ->
    bottomBarProps =
      availableLocales: IntlStore.availableLocales
      locale: @state.locale

    bc = @state.breadcrumb
    console.log "BC", bc

    classes = 'comp-page'
    if @props.element.displayName
      classes += ' ' + @props.element.displayName

    div className: classes,
      topBar {}
      section className: 'main-section',
        breadcrumb bc if (bc? && bc.list.length > 0)
        div id: 'content',
          React.createElement @props.element, _.omit(@props, 'element')
      bottomBar bottomBarProps
