React = require 'react'
ReactIntl = require 'react-intl'
{ div } = React.DOM

module.exports = React.createClass

  displayName: 'indicator'

  mixins: [ReactIntl]

  render: ->

    div id: @props.id, className: 'comp-indicator',
      div className: 'on'