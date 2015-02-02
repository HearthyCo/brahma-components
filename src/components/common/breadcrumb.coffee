React = require 'react/addons'
ReactIntl = require 'react-intl'

{ div, span, a } = React.DOM

module.exports = React.createClass

  displayName: 'breadcrumb'

  mixins: [ReactIntl]

  propTypes:
    values: React.PropTypes.object.isRequired
    breadcrumb: React.PropTypes.func.isRequired

  getInitialState: ->
    subscriptions: { listeners: [] }

  componentDidMount: ->
    @updateBreadcrumb @props

  componentWillReceiveProps: (next) ->
    @updateBreadcrumb next

  componentWillUnmount: ->
    for subscription in @state.subscriptions.listeners
      subscription.store.removeChangeListener subscription.handler

  updateBreadcrumb: (props) ->
    subscriptions = @state.subscriptions.listeners
    for subscription in subscriptions
      subscription.store.removeChangeListener subscription.handler

    subscriptions.listeners = []
    breadcrumb = @state.subscriptions.breadcrumb

    if breadcrumb? && breadcrumb.stores?
      for store in breadcrumb.stores
        objectSubscription = {}
        objectSubscription.store = store
        objectSubscription.handler = -> @updateBreadcrumb props.values
        objectSubscription.store.addChangeListener objectSubscription.handler
        subscriptions.listeners.push objectSubscription

    objectState = listeners: subscriptions
    if props.breadcrumb?
      objectState.breadcrumb = props.breadcrumb.call @, props.values
    else
      objectState.breadcrumb = store: [], list: []

    @setState subscriptions: objectState

  render: ->
    breadcrumb = @state.subscriptions.breadcrumb
    return false unless breadcrumb

    div className: 'comp-breadcrumb',
      breadcrumb.list.map (crumb, i) ->
        a href: crumb.link, key: i, className: 'crumb',
          span className: 'icon icon-' + crumb.className
          span className: 'label',
            crumb.label