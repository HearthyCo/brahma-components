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
  if 'function' is typeof link
    link()
  else
    PageActions.navigate link

funcOrString = (f, args...) ->
  page = window.brahma.currentPage # holy mother of gosh
  if typeof f is 'function'
    wrapper = ->
      f.apply page, args
    return wrapper
  else
    return f

updateBreadcrumb = (element, props) ->
  crumbs = []

  while true
    if element.crumb
      if not _.isArray element.crumb
        element.crumb = [element.crumb]
      # Generate current crumb
      for _crumb in element.crumb
        do (_crumb) ->
          crumb =
            props: props
            label: -> funcOrString _crumb.title, props
            link: -> funcOrString _crumb.url, props
            stores: -> funcOrString _crumb.stores or [], props
            className: -> funcOrString 'TODO: Change me', props
          crumbs.push crumb
    break unless element.parent

    # Go up one level
    element = element.parent props
    _.extend props, element.parentProps props if element.parentProps

  BreadcrumbStore.list = crumbs
  BreadcrumbStore.trigger 'change'


AppDispatcher.on 'all', (eventName, payload) ->
  switch eventName
    when 'page:Change'
      element = payload.page
      props = payload.opts
      updateBreadcrumb element, props


window.brahma.stores.breadcrumb = module.exports = BreadcrumbStore