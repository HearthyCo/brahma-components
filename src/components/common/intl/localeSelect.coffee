React = require 'react'
Backbone = require 'exoskeleton'

module.exports = React.createClass(

  propTypes:
    availableLocales: React.PropTypes.array.isRequired
    value: React.PropTypes.string
    onChange: React.PropTypes.func

  handleChange: (ev) ->
    @props.onChange ev.target.value

  render: ->
    React.createElement 'select',
      className: 'locale-select'
      value: @props.value
      onChange: @handleChange,
      @props.availableLocales.map((locale) ->
        React.createElement 'option',
          key: locale
          value: locale,
          locale
      )
)