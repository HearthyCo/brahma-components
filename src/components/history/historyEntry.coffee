React = require 'react'
ReactIntl = require '../../mixins/ReactIntl'

{ div, span, h2 } = React.DOM

module.exports = React.createClass

  displayName: 'historyentry'

  mixins: [ReactIntl]

  render: ->

    # fake content
    code = '(000714) '
    title = 'Vacuna subcutánea antiviral'
    historyEntryText =
      '''
      Pueden provocar reacción local, inflamación, formación de granuloma y
      necrosis.
      La técnica de aplicación SC se efectúa con el bisel a 45º hacia arriba.
      No es necesario aspirar
      Por esta vía se aplican las vacunas antivirales vivas atenuadas.
      '''
    # end fake content

    div id: @props.id, className: 'comp-historyentry',
      h2 className: 'history-header',
        span className: 'history-code', @props.history?.code or code
        span className: 'history-title', @props.history?.title or title
      div className: 'history-body',
        @props.history?.content or historyEntryText

