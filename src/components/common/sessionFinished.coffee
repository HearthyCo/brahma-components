React = require 'react'
_ = require 'underscore'
ReactIntl = require '../../mixins/ReactIntl'

ModalActions = require '../../actions/ModalActions'

{ span, div, h2, p, button, a } = React.DOM

module.exports = React.createClass

  displayName: 'sessionFinished'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    session: React.PropTypes.object

  render: ->
    div id: @props.id, className: 'comp-sessionFinished',
      div className: 'content',
        h2 {}, @getIntlMessage 'session-finished'
        p {}, @getIntlMessage 'report-access'
        a
          href: '/session/' + @props.session.id
          className: 'view-report',
          @getIntlMessage 'view-report'
        div className: 'image-report'
