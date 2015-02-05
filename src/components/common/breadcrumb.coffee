React = require 'react/addons'
ReactIntl = require 'react-intl'

{ div, span, a } = React.DOM

module.exports = React.createClass

  displayName: 'breadcrumb'

  mixins: [ReactIntl]

  propTypes:
    values: React.PropTypes.object.isRequired
    breadcrumb: React.PropTypes.func

  getInitialState: ->
    subscriptions: []

  componentDidMount: ->
    @updateBreadcrumb()

  componentWillReceiveProps: (next) ->
    @updateBreadcrumb next

  componentWillUnmount: ->
    for subscription in @state.subscriptions
      subscription.store.removeChangeListener subscription.handler

  updateBreadcrumb: (props) ->
    props = props || @props

    subscriptions = @state.subscriptions
    for subscription in subscriptions
      subscription.store.removeChangeListener subscription.handler

    subscriptions = []
    objectState = {}
    if props.breadcrumb?
      objectState.breadcrumb = props.breadcrumb props.values
    else
      objectState.breadcrumb = stores: [], list: -> []

    breadcrumb = objectState.breadcrumb

    _this = @
    if breadcrumb? && breadcrumb.stores?
      for store in breadcrumb.stores
        objectSubscription = {}
        objectSubscription.store = store
        objectSubscription.handler = -> _this.updateBreadcrumb()
        objectSubscription.store.addChangeListener objectSubscription.handler
        subscriptions.push objectSubscription

    objectState.subscriptions = subscriptions

    @setState objectState

  render: ->
    breadcrumb = @state.breadcrumb
    return false unless breadcrumb
    list = breadcrumb.list.call @
    return false unless list.length

    list.unshift
      label: 'home'
      link: '/home'
      className: 'casita'

    div className: 'comp-breadcrumb',
      list.map (crumb, i) ->
        a href: crumb.link, key: i, className: 'crumb',
          span className: 'icon icon-' + crumb.className
          span className: 'label',
            crumb.label