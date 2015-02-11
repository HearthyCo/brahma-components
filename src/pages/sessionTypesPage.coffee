React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

ServiceStore = require '../stores/ServiceStore'

ServiceActions = require '../actions/ServiceActions'

ServiceEntry = React.createFactory require '../components/session/serviceEntry'

{ div, h1 } = React.DOM

module.exports = React.createClass

  displayName: 'sessionTypesPage'
  statics:
    sectionName: 'sessionSection'

  mixins: [ReactIntl]

  getInitialState: ->
    services: ServiceStore.get

  componentDidMount: ->
    ServiceStore.addChangeListener @updateServices
    SessionActions.refresh()

  componentWillUnmount: ->
    ServiceStore.removeChangeListener @updateServices

  updateServices: () ->
    @setState services: ServiceStore.get

  render: ->
    services = @state.services.map (service) ->
      console.log "SERVICE ", service
      # ServiceEntry key: service.id, service: service

    # div className: 'page-sessionTypes',
    #   services