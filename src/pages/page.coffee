React = require 'react'
ReactIntl = require 'react-intl'
_ = require 'underscore'

IntlStore = require '../stores/IntlStore'

topBar = React.createFactory require '../components/common/topBar'
bottomBar = React.createFactory require '../components/common/bottomBar'

{ section, div } = React.DOM

module.exports = React.createClass

  mixins: [ReactIntl]

  childContextTypes:
    availableLocales: React.PropTypes.array.isRequired
    locale: React.PropTypes.string.isRequired
    messages: React.PropTypes.object.isRequired

  getInitialState: ->
    locale: IntlStore.locale
    messages: IntlStore.messages

  getChildContext: ->
    availableLocales: IntlStore.availableLocales
    locale: @state.locale
    messages: @state.messages[@state.locale]
    formats: IntlStore.formats

  componentDidMount: ->
    IntlStore.addChangeListener @updateLocale

  componentWillUnmount: ->
    TodoStore.removeChangeListener @updateLocale

  updateLocale: () ->
    @setState { locale: IntlStore.locale, messages: IntlStore.messages }

  render: ->
    bottomBarProps =
      availableLocales: IntlStore.availableLocales
      locale: @state.locale

    div className: 'comp-page',
      topBar {}
      section className: 'main-section',
        div id: 'content',
          React.createElement @props.element
      bottomBar bottomBarProps
