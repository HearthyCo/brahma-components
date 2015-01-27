React = require 'react'
ReactIntl = require 'react-intl'

{ div, img, span, a } = React.DOM

SessionEntry = React.createFactory require './sessionEntry'

module.exports = React.createClass

  displayName: 'sessionlist'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    title: React.PropTypes.string.isRequired
    sessions: React.PropTypes.array.isRequired
    url: React.PropTypes.string.isRequired

  render: ->
    div id: @props.id, className: 'comp-sessionlist',
      div className: 'sessions-title',
        @props.title
      div className: 'sessions',
        @props.sessions.map (session) ->
          SessionEntry key: session.id, session: session
      a className: 'sessions-more', href: @props.url,
        @getIntlMessage('view-more')
