React = require 'react'
ReactIntl = require '../../mixins/ReactIntl'
{ div } = React.DOM

module.exports = React.createClass

  displayName: 'indicator'

  mixins: [ReactIntl]

  propTypes:
    value: React.PropTypes.bool

  render: ->

    div id: @props.id, className: 'comp-indicator',
      div className: if @props.value then 'on' else 'off'