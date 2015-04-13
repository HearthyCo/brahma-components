React = require 'react/addons'
ReactIntl = require '../../mixins/ReactIntl'

BreadcrumbStore = require '../../stores/BreadcrumbStore'

{ div, span, a } = React.DOM

module.exports = React.createClass

  displayName: 'breadcrumb'

  mixins: [ReactIntl]

  propTypes:
    current: React.PropTypes.node.isRequired
    props: React.PropTypes.object.isRequired

  getInitialState: ->
    subscriptions: []

  componentDidMount: ->
    BreadcrumbStore.addChangeListener @updateBreadcrumb
    @updateBreadcrumb()

  componentWillReceiveProps: (next) ->
    @updateBreadcrumb next

  componentWillUnmount: ->
    BreadcrumbStore.removeChangeListener @updateBreadcrumb
    for subscription in @state.subscriptions
      subscription.store.removeChangeListener subscription.handler

  updateBreadcrumb: () ->
    breadcrumb = BreadcrumbStore.getBreadcrumb()
    values = BreadcrumbStore.getOpts()

    subscriptions = @state.subscriptions
    for subscription in subscriptions
      subscription.store.removeChangeListener subscription.handler

    subscriptions = []
    objectState = {}
    if breadcrumb?
      objectState.breadcrumb = breadcrumb values
    else
      objectState.breadcrumb = stores: [], list: -> []

    breadcrumb = objectState.breadcrumb

    _this = @
    if breadcrumb? and breadcrumb.stores?
      for store in breadcrumb.stores
        objectSubscription = {}
        objectSubscription.store = store
        objectSubscription.handler = -> _this.updateBreadcrumb()
        objectSubscription.store.addChangeListener objectSubscription.handler
        subscriptions.push objectSubscription

    objectState.subscriptions = subscriptions

    @setState objectState

  render: ->
    #breadcrumb = @state.breadcrumb
    #return false unless breadcrumb
    #list = breadcrumb.getList.call @
    #return false unless list.length
    list = BreadcrumbStore.getList()

    list.unshift
      label: -> 'home'
      link: -> '/home'
      className: -> 'home'

    div className: 'comp-breadcrumb',
      list.map (crumb, i) =>
        link = crumb.link()
        href = link if typeof link is 'string'
        onClick = link if typeof link is 'function'
        tag = if href then a else span
        # React doesn't remove empty href, and we can't cancel the click event
        # See https://github.com/facebook/react/issues/1448
        tag href: href, onClick: onClick, key: i, className: 'crumb',
          span className: 'icon icon-' + crumb.className()
          span className: 'label',
            crumb.label.bind @