React = require 'react'
Backbone = require 'exoskeleton'

module.exports = React.createClass

  propTypes:
    availableLocales: React.PropTypes.array.isRequired
    value: React.PropTypes.string
    onChange: React.PropTypes.func.isRequired

  childContextTypes:
    locale: React.PropTypes.string.isRequired
    messages: React.PropTypes.object.isRequired

  handleChange: (ev) ->
    @props.onChange ev.target.value

  render: ->
    React.createElement 'select',
      className: 'comp-localeSelect'
      value: @props.value
      onChange: @handleChange,
      @props.availableLocales.map (locale) ->
        React.createElement 'option',
          key: locale, value: locale,
          locale
