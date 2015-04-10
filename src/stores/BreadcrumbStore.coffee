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
  list: BreadcrumbStore.list

BreadcrumbStore.getOpts = ->
  BreadcrumbStore.opts

BreadcrumbStore.getUp = ->
  list = BreadcrumbStore.list
  crumb = link: -> '/home'
  crumb = list[list.length - 2] if list.length > 1
  crumb

BreadcrumbStore.goUp = ->
  link = BreadcrumbStore.getUp()
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
      opts = payload.opts
      if opts.breadcrumb?
        BreadcrumbStore.breadcrumb = opts.breadcrumb
        BreadcrumbStore.opts = _.omit(opts, 'breadcrumb')
        breadcrumb = BreadcrumbStore.breadcrumb
        BreadcrumbStore.list = breadcrumb(BreadcrumbStore.opts).list()
      else
        BreadcrumbStore.breadcrumb = null
        BreadcrumbStore.opts = {}
        BreadcrumbStore.list = []

      BreadcrumbStore.trigger 'change'

module.exports = BreadcrumbStore