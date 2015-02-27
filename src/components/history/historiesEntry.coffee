React = require 'react'
ReactIntl = require 'react-intl'

{ a, span, div } = React.DOM

module.exports = React.createClass

  displayName: 'historiesEntry'

  mixins: [ReactIntl]

  render: ->

    #     ejemplo de for para los entries (alergia)

    # entries = for key, entries of @props.history
    #   try
    #     title = @getIntlMessage key
    #   catch error
    #     title = key

    entry = div className: 'value', 'Bisolvón Forte 500 mg'
    entry2 = div className: 'value', 'telmangin Forte 250 mg'

    div className: 'comp-historiesentry',
      div className: 'label',
        'Reconmendaciones'
      div className: 'entry',
        entry
      div className: 'entry',
        entry2
