React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

AllergyStore = require '../stores/AllergyStore'

AllergyActions = require '../actions/AllergyActions'

{ div, h1, span } = React.DOM

CircleRating = React.createFactory require '../components/common/circleRating'

module.exports = React.createClass

  displayName: 'allergiesPage'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string.isRequired

  getInitialState: ->
    allergy: AllergyStore.get @props.id

  componentDidMount: ->
    AllergyStore.addChangeListener @updateState

  componentWillUnmount: ->
    AllergyStore.removeChangeListener @updateState

  componentWillReceiveProps: (next) ->
    if @props.id isnt next.id
      @setState { allergy: AllergyStore.get next.id }

  updateState: () ->
    @setState { allergy: AllergyStore.get @props.id }

  render: ->
    if not @state.allergy then return div {} # No "property of undefined" errors
    rating = @state.allergy.meta.rating
    div className: 'page-allergy',
      h1 {},
        span className: 'generalTitle', @getIntlMessage('allergy') + ': '
        span className: 'specificTitle', @state.allergy.title
      div className: 'severity',
        span className: 'label', @getIntlMessage('severity') + ': '
        CircleRating value: rating
        span className: 'ratingText', @getIntlMessage('rating-' + rating)
      div className: 'symptoms',
        div className: 'label', @getIntlMessage('symptoms')
        div className: 'value', @state.allergy.description