React = require 'react'
Backbone = require 'exoskeleton'
_ = require 'underscore'
AppDispatcher = require '../dispatcher/AppDispatcher'
PageActions = require '../actions/PageActions'

BreadcrumbStore =
  list: []
  breadcrumb: null
  opts: {}

_.extend BreadcrumbStore, Backbone.Events

BreadcrumbStore.addChangeListener = (callback) ->
  BreadcrumbStore.on 'change', callback

BreadcrumbStore.removeChangeListener = (callback) ->
  BreadcrumbStore.off 'change', callback

BreadcrumbStore.getList = ->
  arr = BreadcrumbStore.list.slice 0
  arr.reverse()

BreadcrumbStore.getUp = ->
  list = BreadcrumbStore.list
  crumb = link: -> '/home'
  crumb = list[list.length - 2] if list.length > 1
  crumb

BreadcrumbStore.goUp = ->
  link = BreadcrumbStore.getUp().link()
  href = link if typeof link is 'string'
  onClick = link if typeof link is 'function'
  PageActions.navigate href if href
  onClick() if onClick
  link

funcOrString = (f, args...) ->
  if typeof f is 'function' then f.apply @, args else f

updateBreadcrumb = (element, props) ->
  crumbs = []
  while true
    if element.crumb
      # Generate current crumb
      do (element) ->
        crumb =
          props: props
          label: -> funcOrString.call @, element.crumb.title, props
          link: -> funcOrString.call @, element.crumb.url, props
          stores: -> funcOrString.call @, element.crumb.stores or [], props
          className: -> funcOrString.call @, 'TODO: Change me', props
        crumbs.push crumb
    break unless element.parent
    # Go up one level
    element = element.parent props
    _.extend props, element.parentProps props if element.parentProps
    console.log 'P:', props, element.parentProps? props

  BreadcrumbStore.list = crumbs
  BreadcrumbStore.trigger 'change'


AppDispatcher.on 'all', (eventName, payload) ->
  switch eventName
    when 'page:Change'
      element = payload.page
      props = payload.opts
      updateBreadcrumb element, props


window.brahma.stores.breadcrumb = module.exports = BreadcrumbStore