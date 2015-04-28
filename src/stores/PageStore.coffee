React = require 'react'
Backbone = require 'exoskeleton'
_ = require 'underscore'
AppDispatcher = require '../dispatcher/AppDispatcher'

PageActions = require '../actions/PageActions'

PageStore =
  history: []
  current: null
  opts: {}

_.extend PageStore, Backbone.Events

PageStore.addChangeListener = (callback) ->
  PageStore.on 'change', callback

PageStore.removeChangeListener = (callback) ->
  PageStore.off 'change', callback

PageStore.getPage = ->
  history: PageStore.history
  current: PageStore.current
  opts: JSON.parse JSON.stringify PageStore.opts

PageStore.goBack = ->
  return null if PageStore.history.length <= 0
  pageObject = PageStore.history.pop()
  opts = pageObject.opts
  opts.isBackNavigation = true

  PageActions.navigate pageObject.route, opts

AppDispatcher.on 'all', (eventName, payload) ->
  switch eventName
    when 'page:Change'
      # If payload.opts has url means that is not back navigation, then push to
      # history. This is to avoid infite back loops
      if PageStore.current? and payload.opts.url?
        url = PageStore.opts.url or '/'
        opts = _.omit PageStore.opts, 'url'
        PageStore.history.push route: url, opts: opts
      PageStore.current = payload.page
      PageStore.opts = payload.opts
      PageStore.trigger 'change'

window.brahma.stores.page = module.exports = PageStore