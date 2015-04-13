React = require 'react'
ReactIntl = require '../../mixins/ReactIntl'

{ a, button, div, span } = React.DOM

module.exports = React.createClass

  displayName: 'reportTaskEntry'

  mixins: [ReactIntl]

  render: ->

    div className: 'comp-reportTaskEntry',
      div className: 'treatment-type',
        span className: 'type', @getIntlMessage 'recommended'
        button className:'create-task',
          @getIntlMessage 'create'

      div className: 'treatment-type',
        span className: 'type', @getIntlMessage 'drugs'
        button className:'create-task',
          @getIntlMessage 'create'

