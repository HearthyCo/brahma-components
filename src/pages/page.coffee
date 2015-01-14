React = require 'react'
ReactIntl = require 'react-intl'
_ = require 'underscore'

IntlActions = require '../actions/IntlActions'

topBar = React.createFactory require '../components/common/topBar'
bottomBar = React.createFactory require '../components/common/bottomBar'

{ section, div } = React.DOM

module.exports = React.createClass

  mixins: [ReactIntl]

  childContextTypes:
    locale: React.PropTypes.string.isRequired
    messages: React.PropTypes.object.isRequired

  getInitialState: ->
    locale: @props.intl.locale
    messages: @props.intl.messages

  getChildContext: ->
    locale: @state.locale
    messages: @state.messages[@state.locale]

  translate: (locale, messages) ->
    @setState { locale: locale, messages: _.extend(@state.messages, messages) }

  updateLocale: (newLocale) ->
    # if the language does not yet exists then download it
    unless @state.messages[newLocale]
      IntlActions.translate newLocale, @translate
    else
      # if language already exists loaded it
      @translate newLocale

  render: ->
    # no need for ReactLink
    localeLink =
      value: @state.locale
      requestChange: @updateLocale

    bottomBarProps =
      availableLocales: @props.intl.availableLocales
      locale: localeLink

    div className: 'comp-page',
      topBar {}
      section className: 'main-section',
        div id: 'content',
          React.createElement @props.element
      bottomBar bottomBarProps
