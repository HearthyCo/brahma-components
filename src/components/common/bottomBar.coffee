React = require 'react/addons'
_ = require 'underscore'

LocaleSelect = React.createFactory(
  require './intl/localeSelect'
)

{ footer, div } = React.DOM

module.exports = React.createClass
  render: ->
    footer className: 'comp-bottomBar',
      div className: 'left-box',
        "Left"
      div className: 'center-box',
        "Center"
      div className: 'right-box',
        div id: 'locale-select',
          LocaleSelect
            availableLocales: @props.availableLocales
            value: @props.locale.value
            onChange: @props.locale.requestChange
