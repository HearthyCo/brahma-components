React = require 'react'
Backbone = require 'exoskeleton'
_ = require 'underscore'
AppDispatcher = require '../dispatcher/AppDispatcher'

PageStore =
  next: null
  current: null
  opts: {}

_.extend ModalStore, Backbone.Events

getRendererFor = (element, breadcrumb, keys...) -> (values...) ->
  args = {}
  args.values = _.object ([key, values[i]] for key, i in keys)
  args.element = element
  args.breadcrumb = breadcrumb if breadcrumb?
  React.render React.createElement((require './pages/page'), args), document.body



PageStore.addChangeListener = (callback) ->
  PageStore.on 'change', callback

PageStore.removeChangeListener = (callback) ->
  PageStore.off 'change', callback

PageStore.getPage = ->
  next: PageStore.next
  current: PageStore.current
  opts: JSON.parse JSON.stringify PageStore.opts

AppDispatcher.on 'all', (eventName, payload) ->
  switch eventName
    when 'page:navigate'
      PageStore.next = PageStore.current
      PageStore.current = payload.page
      PageStore.opts = payload.opts
      PageStore.trigger 'change'

module.exports = PageStore