React = require 'react'
Backbone = require 'exoskeleton'
_ = require 'underscore'
AppDispatcher = require '../dispatcher/AppDispatcher'

PageStore =
  current: null
  breadcrumb: null
  opts: {}

_.extend PageStore, Backbone.Events

PageStore.addChangeListener = (callback) ->
  PageStore.on 'change', callback

PageStore.removeChangeListener = (callback) ->
  PageStore.off 'change', callback

PageStore.getPage = ->
  current: PageStore.current
  breadcrumb: PageStore.breadcrumb
  opts: JSON.parse JSON.stringify PageStore.opts

AppDispatcher.on 'all', (eventName, payload) ->
  switch eventName
    when 'page:Change'
      opts = payload.opts
      PageStore.current = payload.page
      PageStore.breadcrumb = opts.breadcrumb
      PageStore.opts = _.omit(opts, 'breadcrumb')
      PageStore.trigger 'change'

module.exports = PageStore