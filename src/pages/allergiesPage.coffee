React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

HistoryStore = require '../stores/HistoryStore'

HistoryActions = require '../actions/HistoryActions'

AllergyEntry = React.createFactory require '../components/history/allergyEntry'

{ div, h1 } = React.DOM

module.exports = React.createClass

  displayName: 'allergiesPage'
  statics:
    sectionName: 'historySection'

  mixins: [ReactIntl]

  getInitialState: ->
    allergies: HistoryStore.getSection 'allergies'

  componentDidMount: ->
    HistoryStore.addChangeListener @updateState
    HistoryActions.refresh 'allergies'

  componentWillUnmount: ->
    HistoryStore.removeChangeListener @updateState

  updateState: () ->
    @setState allergies: HistoryStore.getSection 'allergies'

  render: ->
    allergies = @state.allergies.map (allergy) ->
      AllergyEntry key: allergy.id, allergy: allergy

    div className: 'page-allergies',
      h1 {}, @getIntlMessage('allergies')
      allergies