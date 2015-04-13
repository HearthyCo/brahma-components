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
  BreadcrumbStore.list.slice 0

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

BreadcrumbStore.getBreadcrumb = ->
  BreadcrumbStore.breadcrumb

AppDispatcher.on 'all', (eventName, payload) ->
  switch eventName
    when 'page:Change'
      crumbs = []
      element = payload.page
      props = payload.opts
      while true
        if element.crumb
          # Generate current crumb
          do (element) ->
            crumb =
              label: -> element.crumb.title props
              link: -> element.crumb.url props
              stores: -> element.crumb.stores props
              className: -> 'TODO: Change me'
            crumbs.push crumb
        break unless element.parent
        # Go up one level
        element = element.parent props
        _.extend props, element.parentProps props if element.parentProps

      BreadcrumbStore.list = crumbs
      BreadcrumbStore.trigger 'change'


window.brahma.stores.breadcrumb = module.exports = BreadcrumbStore