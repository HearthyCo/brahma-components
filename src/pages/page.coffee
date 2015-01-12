React = require 'react'
ReactIntl = require 'react-intl'

LocaleSelect = React.createFactory require '../components/intl/localeSelect'

{ section, div } = React.DOM

module.exports = React.createClass

  mixins: [ReactIntl]

  getInitialState: ->
    { locale: @props.intl.locale }

  updateLocale: (newLocale) ->
    @setState { locale: newLocale }

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
          messages: @props.intl.messages[@state.locale]
      )
    )
