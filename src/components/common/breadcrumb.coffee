React = require 'react/addons'
ReactIntl = require '../../mixins/ReactIntl'

BreadcrumbStore = require '../../stores/BreadcrumbStore'
PageActions = require '../../actions/PageActions'

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
    list = BreadcrumbStore.getList()
    subscriptions = []

    for crumb in list
      stores = crumb.stores()
      for store in stores
        objectSubscription = {}
        objectSubscription.store = store
        objectSubscription.handler = => @updateBreadcrumb()
        objectSubscription.store.addChangeListener objectSubscription.handler
        subscriptions.push objectSubscription

    objectState = subscriptions: subscriptions
    @setState objectState if @isMounted()

  render: ->
    list = BreadcrumbStore.getList()
    return false if not list.length
    list.unshift
      label: -> 'home'
      link: -> '/home'
      className: -> 'home'

    div className: 'comp-breadcrumb',
      list.map (crumb, i) ->
        link = crumb.link()
        if typeof link is 'function'
          onClick = link
        else
          href = link
          onClick = (e) ->
            e.preventDefault()
            PageActions.navigate link, crumb.props
        tag = if href then a else span
        # React doesn't remove empty href, and we can't cancel the click event
        # See https://github.com/facebook/react/issues/1448
        tag
          href: href
          onClick: onClick
          rel: 'norouter'
          key: i
          className: 'crumb',

          span className: 'icon icon-' + crumb.className()
          span className: 'label',
            crumb.label()
