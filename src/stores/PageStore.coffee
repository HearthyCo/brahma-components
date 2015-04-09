React = require 'react'
Backbone = require 'exoskeleton'
_ = require 'underscore'
AppDispatcher = require '../dispatcher/AppDispatcher'

PageStore =
  history: []
  current: '/'
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

PageStore.getBack = ->
  back = PageStore.history[0]
  back = PageStore.history.pop() if PageStore.history.length > 1
  back

AppDispatcher.on 'all', (eventName, payload) ->
  switch eventName
    when 'page:Change'
      PageStore.history.push PageStore
      PageStore.current = payload.page
      PageStore.opts = _.omit payload.opts, 'breadcrumb'
      PageStore.trigger 'change'
    when 'page:Back'
      console.log "page:Back"
      PageStore = PageStore
      PageStore.trigger 'change'

module.exports = PageStore