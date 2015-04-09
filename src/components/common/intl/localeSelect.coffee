React = require 'react'
Backbone = require 'exoskeleton'

IntlActions = require '../../../actions/IntlActions'

locales = (locale) ->
  _locales =
    'ca-ES': 'Català'
    'en-US': 'English'
    'es-ES': 'Español'
    'eu-ES': 'Euskara'
    'fr-FR': 'Français'
    'it-IT': 'Italiano'
    'de-DE': 'Deutsch'
    'gl-ES': 'Galego'
    'pt-PT': 'Português'

  if _locales.hasOwnProperty locale
    return _locales[locale]
  else
    return locale

module.exports = React.createClass

  displayName: 'localeSelect'

  contextTypes:
    availableLocales: React.PropTypes.array.isRequired
    locale: React.PropTypes.string.isRequired
    messages: React.PropTypes.object.isRequired

  handleChange: (ev) ->
    IntlActions.requestChange ev.target.value

  render: ->
    React.createElement 'select',
      className: 'comp-localeSelect'
      value: @context.locale
      onChange: @handleChange,
      @context.availableLocales.map (locale) ->
        React.createElement 'option',
          key: locale, value: locale,
          locales(locale)
