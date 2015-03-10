React = require 'react'
ReactIntl = require 'react-intl'

{ a, span, div, strong, p } = React.DOM

Trigger = React.createFactory require '../common/form/trigger'
Indicator = React.createFactory require '../common/indicator'

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
          span {}, @getIntlMessage 'dosage-done?'
          Indicator {}
        div className: 'enable',
          span {}, @getIntlMessage 'enable-notifications'
          Trigger {}
          p {}, @getIntlMessage 'this-medication'
      div className: 'label',
        @getIntlMessage 'details'
      div className: 'details',
        div {},
          strong {}, @getIntlMessage('medication') + ' : '
          span {}, medication
        div {},
          strong {}, @getIntlMessage('pharmaceutical-form') + ' : '
          span {}, pharmaceuticalForm
        div {},
          strong {}, @getIntlMessage('quantity') + ' : '
          span {}, quantity
        div {},
          strong {}, @getIntlMessage('formula') + ' : '
          span {}, formula
        div {},
          strong {}, @getIntlMessage('instructions') + ' : '
          span {}, instructions
        div {},
          strong {}, @getIntlMessage('duration') + ' : '
          span {}, duration
