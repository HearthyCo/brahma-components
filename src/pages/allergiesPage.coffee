React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

AllergyStore = require '../stores/AllergyStore'

AllergyActions = require '../actions/AllergyActions'

AllergyEntry = React.createFactory(
  require '../components/history/allergyEntry'
)

{ div, h1 } = React.DOM

module.exports = React.createClass

  displayName: 'allergiesPage'
  statics: sectionName: 'historySection'

  mixins: [ReactIntl]

  getInitialState: ->
    allergies: AllergyStore.getAll()

  componentDidMount: ->
    AllergyStore.addChangeListener @updateState
    AllergyActions.refresh()

  componentWillUnmount: ->
    AllergyStore.removeChangeListener @updateState

  updateState: () ->
    @setState { allergies: AllergyStore.getAll() }

  render: ->
    allergies = @state.allergies.map (allergy) ->
      AllergyEntry key: allergy.id, allergy: allergy

    div className: 'page-allergies',
      h1 {}, @getIntlMessage('allergies')
      allergies