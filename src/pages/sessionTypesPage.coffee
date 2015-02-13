React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

ServiceStore = require '../stores/ServiceStore'

ServiceActions = require '../actions/ServiceActions'

SubListEntry = React.createFactory require '../components/common/sublistEntry'

{ div, h1, span, strong } = React.DOM

module.exports = React.createClass

  displayName: 'sessionTypesPage'
  statics:
    sectionName: 'sessionSection'

  mixins: [ReactIntl]

  getInitialState: ->
    services: ServiceStore.getAll()

  componentDidMount: ->
    ServiceStore.addChangeListener @updateServices
    ServiceActions.refresh()

  componentWillUnmount: ->
    ServiceStore.removeChangeListener @updateServices

  updateServices: () ->
    @setState services: ServiceStore.getAll()

  render: ->
    _this = @
    createPaypal = -> TransactionActions.createPaypal _this.state.amount

    services = @state.services.map (field) ->
      for services of field
        field[services].map (service) ->
          serviceOpt =
            key: service.id
            id: service.id
            label: service.name
            sublabel: 'Tiempo de espera'

          SubListEntry serviceOpt,
            div className: 'title',
              span {},
                'Esta operacion tiene un cargo de'
              strong {},
                '3€'
              span {},
                'que se te descontaran'

            div className: 'button', onClick: createPaypal,
              _this.getIntlMessage 'continue'

    div className: 'page-sessionTypes',
      div className: 'availableProfessionals',
        span {},
          'Actualmente hay'
        span className: 'professional-number',
          '0'
        span {},
          'medicos disponibles'
      services