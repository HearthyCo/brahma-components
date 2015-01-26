React = require 'react'
ReactIntl = require 'react-intl'

{ div, img, span, a } = React.DOM

Datetime = React.createFactory require '../common/datetime'

module.exports = React.createClass

  displayName: 'sessionentry'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    session: React.PropTypes.object.isRequired


  render: ->
    div id: @props.id, className: 'comp-sessionentry',
      div className: 'session-label',
        Datetime value: @props.session.startDate
        span className: 'session-title', @props.session.title
      a className: 'session-link', href: '/session/' + @props.session.id,
        @getIntlMessage('access')