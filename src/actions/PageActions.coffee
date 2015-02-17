AppDispatcher = require '../dispatcher/AppDispatcher'
_ = require 'underscore'
Backbone = require 'exoskeleton'

block = false

PageActions =
  navigate = (route, opts) ->
    if block return

    block = opts
    router.navigate route, trigger: true

  change = (page, opts) ->
    t = block || {}
    block = false
    _.extend t, opts

    AppDispatcher.trigger 'page:navigate',
      page: page, opts: t

module.exports = PageActions