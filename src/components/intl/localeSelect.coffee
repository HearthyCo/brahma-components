React = require 'react'

module.exports = React.createClass(

  propTypes:
    availableLocales: React.PropTypes.array.isRequired
    value: React.PropTypes.string
    onChange: React.PropTypes.func
    valueLink: React.PropTypes.shape(
      value: React.PropTypes.string.isRequired
      requestChange: React.PropTypes.func.isRequired
    )

  getValueLink: (props) ->
    props.valueLink or
      value: props.value
      requestChange: props.onChange

  handleChange: (e) ->
    @getValueLink(@props).requestChange e.target.value
    return

  render: ->
    value = @getValueLink(@props).value

    console.log 'VALUE', value

    React.createElement 'select',
      className: 'locale-select'
      value: value
      onChange: @handleChange
      , @props.availableLocales.map((locale) ->
        React.createElement 'option',
          key: locale
          value: locale
          , locale
      )
)