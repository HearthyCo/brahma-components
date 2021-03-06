React = require 'react/addons'
_ = require 'underscore'

LocaleSelect = React.createFactory require './intl/localeSelect'

{ footer, div } = React.DOM

module.exports = React.createClass

  displayName: 'bottomBar'

  render: ->
    footer className: 'comp-bottomBar wrapper',
      div className: 'left-box',
      div className: 'center-box',
      div className: 'right-box',
        div id: 'locale-select',
          LocaleSelect {}
