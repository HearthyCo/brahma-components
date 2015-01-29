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
    messages: IntlStore.messages

  getChildContext: ->
    availableLocales: IntlStore.availableLocales
    locale: @state.locale
    messages: @state.messages[@state.locale]
    formats: IntlStore.formats
    user: @state.user

  componentDidMount: ->
    IntlStore.addChangeListener @updateLocale
    UserStore.addChangeListener @updateUser

  componentWillUnmount: ->
    IntlStore.removeChangeListener @updateLocale
    UserStore.removeChangeListener @updateUser

  updateLocale: () ->
    @setState locale: IntlStore.locale, messages: IntlStore.messages

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

    console.log "BREADCRUMBS ", @props.breadcrumb

    classes = 'comp-page'
    if @props.element.displayName
      classes += ' ' + @props.element.displayName

    div className: classes,
      topBar {}
      breadcrumb @props.breadcrumb if @props.breadcrumb.list.length > 0
      section className: 'main-section',
        div id: 'content',
          React.createElement @props.element, _.omit(@props, 'element')
      bottomBar bottomBarProps
