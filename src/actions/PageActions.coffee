AppDispatcher = require '../dispatcher/AppDispatcher'
_ = require 'underscore'
Backbone = require 'exoskeleton'

block = false

PageActions =
  navigate: (route, opts) ->
    return if block

    block = if opts? then opts else {}
    window.router.navigate route, trigger: true

  change: (page, opts) ->
    t = block || {}
    block = false
    _.extend t, opts

    AppDispatcher.trigger 'page:change',
      page: page, opts: t

module.exports = PageActions