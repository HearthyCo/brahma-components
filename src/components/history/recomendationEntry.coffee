React = require 'react'
ReactIntl = require '../../mixins/ReactIntl'

{ a, span, div } = React.DOM

module.exports = React.createClass

  displayName: 'recomendationEntry'

  mixins: [ReactIntl]

  render: ->

    entry = 'Realiza ejercicio por lo menos dos veces al día. Estiramiento y ya'

    div className: 'comp-recomendationEntry',
      div className: 'label',
        @getIntlMessage 'details'
      div className: 'wrapper',
        entry
