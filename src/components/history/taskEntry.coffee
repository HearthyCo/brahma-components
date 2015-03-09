React = require 'react'
ReactIntl = require 'react-intl'

{ a, span, div, strong, p } = React.DOM

module.exports = React.createClass

  displayName: 'taskEntry'

  mixins: [ReactIntl]

  render: ->

    medication = 'Bisoplvon forte'
    quantity = '37'
    pharmaceuticalForm = '200g'
    formula = 'Oral'
    instructions = '2 comp. cada 8h'
    duration = '4 días'

    div className: 'comp-taskEntry',
      div className: 'wrapper mini-cp',
        div className: 'taking-of',
          span {}, 'dosages-done?'
        div className: 'enable',
          span {}, 'enable-notifications'
          p {}, 'this-medication'
      div className: 'label',
        'Detalles'
      div className: 'wrapper details',
        div {},
          strong {}, 'Medication :'
          span {}, medication
        div {},
          strong {}, 'Pharmaceutical form :'
          span {}, pharmaceuticalForm
        div {},
          strong {}, 'Quantity :'
          span {}, quantity
        div {},
          strong {}, 'Formula :'
          span {}, formula
        div {},
          strong {}, 'Instructions :'
          span {}, instructions
        div {},
          strong {}, 'Duration :'
          span {}, duration
