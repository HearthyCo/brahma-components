React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

#AllergyStore = require '../stores/AllergiesStore'

#AllergyActions = require '../actions/AllergiesActions'

{ div, h1, span } = React.DOM

CircleRating = React.createFactory require '../components/common/circleRating'

module.exports = React.createClass

  displayName: 'allergiesPage'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string.isRequired

  getInitialState: ->
    # TODO: Change to use store:
    #allergy: AllergyStore.get @props.id
    allergy: {id: 1, title: 'Polen', description: 'Síntoma...', meta: rating: 5}

  componentDidMount: ->
    #AllergyStore.addChangeListener @updateState

  componentWillUnmount: ->
    #AllergyStore.removeChangeListener @updateState

  updateState: () ->
    @setState { allergy: AllergyStore.get @props.id }

  render: ->
    rating = @state.allergy.meta.rating
    div className: 'page-allergy',
      h1 {},
        span className: 'generalTitle', @getIntlMessage('allergy')
        span className: 'specificTitle', @state.allergy.title
      div className: 'severity',
        span className: 'label', @getIntlMessage('severity')
        CircleRating value: rating
        span className: 'ratingText', @getIntlMessage('rating-' + rating)
      div className: 'symptoms',
        div className: 'label', @getIntlMessage('symptoms')
        div className: 'value', @state.allergy.description