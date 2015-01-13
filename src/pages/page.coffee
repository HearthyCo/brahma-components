React = require 'react'
ReactIntl = require 'react-intl'
_ = require 'underscore'

IntlActions = require '../actions/IntlActions'
LocaleSelect = React.createFactory(
  require '../components/common/intl/localeSelect'
)

{ section, div } = React.DOM

module.exports = React.createClass

  mixins: [ReactIntl]

  getInitialState: ->
    locale: @props.intl.locale
    messages: @props.intl.messages

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
    section(
      id: 'page'
      , div(
        id: 'locale-select'
        , LocaleSelect
          availableLocales: @props.intl.availableLocales
          value: @state.locale
          onChange: @updateLocale
      )
      , div(
        id: 'content'
        , React.createElement @props.element,
          messages: @state.messages[@state.locale]
      )
    )