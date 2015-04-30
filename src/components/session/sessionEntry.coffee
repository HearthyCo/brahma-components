React = require 'react'
ReactIntl = require '../../mixins/ReactIntl'

{ div, img, span, a } = React.DOM

Datetime = React.createFactory require '../common/datetime'
ListStores = require '../../stores/ListStores'
EntityStores = require '../../stores/EntityStores'

urlUtils = require '../../util/urlUtils'

module.exports = React.createClass

  displayName: 'sessionentry'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    session: React.PropTypes.object.isRequired

  getInitialState: ->
    @update()

  componentDidMount: ->
    ListStores.Session.LastViewedMessage.addChangeListener @update
    ListStores.Session.Messages.addChangeListener @update

  componentWillUnmount: ->
    ListStores.Session.LastViewedMessage.removeChangeListener @update
    ListStores.Session.Messages.removeChangeListener @update

  update: ->
    counter = ListStores.Session.LastViewedMessage.getCounter @props.session.id
    state = counter: counter
    @setState state if @isMounted()
    state

  render: ->
    sessionId = @props.session.id
    link = urlUtils.getUrl.session @props.session

    div id: @props.id, className: 'comp-sessionentry',
      a className: 'session-link', href: link,
        div className: 'session-label',
          Datetime value: @props.session.startDate
          span className: 'session-title', @props.session.title
        div className: 'session-notify',
          if @state.counter  > 0
            span className: 'icon icon-advice'