React = require 'react'
Backbone = require 'exoskeleton'

IntlActions = require '../../../actions/IntlActions'

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
          locale
