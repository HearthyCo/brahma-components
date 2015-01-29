React = require 'react'
ReactIntl = require 'react-intl'

{ a, img, span, div } = React.DOM

CircleRating = React.createFactory require '../common/circleRating'

module.exports = React.createClass

  displayName: 'allergyEntry'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    allergy: React.PropTypes.object.isRequired

  render: ->
    rating = @props.allergy.meta.rating
    textRating = @getIntlMessage 'rating-' + rating
    url = '/allergy/' + @props.allergy.id

    a id: @props.id, className: 'comp-allergyentry', href: url,
      div className: 'label',
        @props.allergy.title
      div className: 'value',
        div {}, textRating
        CircleRating value: rating