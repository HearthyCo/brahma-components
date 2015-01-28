React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

#AllergyStore = require '../stores/AllergiesStore'

#AllergyActions = require '../actions/AllergiesActions'

AllergyEntry = React.createFactory(
  require '../components/history/allergyEntry'
)

{ div, h1 } = React.DOM

module.exports = React.createClass

  displayName: 'allergiesPage'

  mixins: [ReactIntl]

  getInitialState: ->
    # TODO: Change to use store:
    #allergies: AllergyStore.getAll()
    allergies: [
      {id: 1, title: 'Polen', meta: rating: 5}
      {id: 2, title: 'Gramíneas', meta: rating: 3}
      {id: 3, title: 'Ácaros', meta: rating: 2}
      {id: 4, title: 'Plátano', meta: rating: 3}
      {id: 5, title: 'Anisakis', meta: rating: 5}
      {id: 6, title: 'Trigo', meta: rating: 3}
    ]

  componentDidMount: ->
    #AllergyStore.addChangeListener @updateState
    #AllergyActions.refresh()

  componentWillUnmount: ->
    #AllergyStore.removeChangeListener @updateState

  updateState: () ->
    @setState { allergies: AllergyStore.getAll() }

  render: ->
    allergies = @state.allergies.map (allergy) ->
      AllergyEntry key: allergy.id, allergy: allergy

    div className: 'page-allergies',
      h1 {}, @getIntlMessage('allergies')
      allergies