React = require 'react'
ReactIntl = require 'react-intl'

{ a, span, div } = React.DOM

module.exports = React.createClass

  displayName: 'recomendationEntry'

  mixins: [ReactIntl]

  render: ->

    entry = 'Realiza ejercicio por lo menos dos veces al día. Estiramiento y ya'

    div className: 'comp-recomendationEntry',
      div className: 'label',
        'Detalles'
      div className: 'wrapper',
        entry
