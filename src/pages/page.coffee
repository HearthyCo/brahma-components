React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

IntlStore = require '../stores/IntlStore'
UserStore = require '../stores/UserStore'
UserActions = require '../actions/UserActions'
ModalStore = require '../stores/ModalStore'
ModalActions = require '../actions/ModalActions'
loginPage = require '../pages/loginPage'

breadcrumb = React.createFactory require '../components/common/breadcrumb'
modal = React.createFactory require '../components/common/modal'
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

  getChildContext: ->
    availableLocales: IntlStore.availableLocales
    locale: @state.locale
    messages: @state.messages
    formats: IntlStore.formats
    user: @state.user

  componentDidMount: ->
    @updateUser()
    IntlStore.addChangeListener @updateLocale
    UserStore.addChangeListener @updateUser
    ModalStore.addChangeListener @updateModal

  componentWillUnmount: ->
    IntlStore.removeChangeListener @updateLocale
    UserStore.removeChangeListener @updateUser
    ModalStore.removeChangeListener @updateModal

  updateLocale: ->
    @setState
      locale: IntlStore.locale
      messages: IntlStore.messages[IntlStore.locale]

  updateUser: ->
    isLogin = not @state.user and UserStore.currentUid
    isLogout = @state.user and not UserStore.currentUid
    @setState user: UserStore.get(UserStore.currentUid)
    # Auto-navigation triggered?
    if isLogin
      window.routerNavigate '/home'
    else if isLogout
      window.routerNavigate '/'

  updateModal: ->
    @setState modal: ModalStore.getModal()


  render: ->
    bottomBarProps =
      availableLocales: IntlStore.availableLocales
      locale: @state.locale

    # Does it need login?
    if not @props.element.isPublic and not UserStore.currentUid
      elementFactory = loginPage
    else
      elementFactory = @props.element

    # Should we show a modal on top?
    currentModal = false
    if @state.modal and @state.modal.visible
      currentModal = modal
        content: @state.modal.content
        onClose: ModalActions.hide

    element = React.createElement elementFactory,
      _.omit(@props.values, 'element')

    classes = 'comp-page'
    if element.type.displayName
      classes += ' ' + element.type.displayName
    if element.type.sectionName
      classes += ' ' + element.type.sectionName

    div className: classes,
      currentModal
      topBar {}
      section className: 'main-section',
        breadcrumb breadcrumb: @props.breadcrumb, values: @props.values
        div id: 'content',
          element
      bottomBar bottomBarProps
