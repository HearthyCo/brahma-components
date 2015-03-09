React = require 'react'
ReactIntl = require 'react-intl'

{ a, span, div } = React.DOM

module.exports = React.createClass

  displayName: 'recomendationEntry'

  mixins: [ReactIntl]

  render: ->

    entry = 'Realizar ejercicio por lo menos dos veces al día. Estiramiento y calentamiento previo'

    div className: 'comp-recomendationEntry',
      div className: 'label',
        'Detalles'
      div className: 'wrapper',
        entry
