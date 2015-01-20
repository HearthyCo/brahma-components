React = require 'react'
ReactIntl = require 'react-intl'

{ div, img, span, p } = React.DOM

module.exports = React.createClass

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    user: React.PropTypes.object.isRequired

  render: ->
    _this = @
    fullname = ['name', 'surname1', 'surname2']
      .map (f) -> _this.props.user.get(f)
      .filter (v) -> v
      .join ' '

    div id: @props.id, className: 'comp-professionalbrief',
      img className: 'avatar', src: @props.user.get('avatar')
      div className: 'brief-info',
        p {},
          span className: 'brief-key', @getIntlMessage('professional'), ': '
          span className: 'brief-value', fullname
        p {},
          span className: 'brief-key', @getIntlMessage('field'), ': '
          span className: 'brief-value', @props.user.get('service')
