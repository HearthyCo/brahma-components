React = require 'react'
Backbone = require 'exoskeleton'
_ = require 'underscore'
AppDispatcher = require '../dispatcher/AppDispatcher'

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

PageStore.getBack = ->
  return null if PageStore.history.length <= 0
  PageStore.history.pop()

AppDispatcher.on 'all', (eventName, payload) ->
  switch eventName
    when 'page:Change'
      if PageStore.current?
        PageStore.history.push current: PageStore.current, opts: PageStore.opts
      PageStore.current = payload.page
      PageStore.opts = payload.opts
      PageStore.trigger 'change'

window.brahma.stores.page = module.exports = PageStore