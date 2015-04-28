AppDispatcher = require '../dispatcher/AppDispatcher'
_ = require 'underscore'
Backbone = require 'exoskeleton'

###coffeelint-variable-scope-ignore###
block = false
###coffeelint-variable-scope-ignore###
timer = false

PageActions =
  navigate: (route, opts) ->
    return if block
    ###coffeelint-variable-scope-ignore###
    timer = window.setTimeout (-> block = false), 500

    ###coffeelint-variable-scope-ignore###
    block = if opts? then opts else {}
    window.brahma.router.navigate route, trigger: true

  change: (page, opts) ->
    t = block or {}

    ###coffeelint-variable-scope-ignore###
    t.url = window.location.hash.replace '#', '/'
    # if isBackNavigation exists then removes url to avoid push current page
    # in history to prevent infite back loops
    if t.isBackNavigation? and t.isBackNavigation
      t = _.omit t, 'url', 'isBackNavigation'

    block = false

    _.extend t, opts

    AppDispatcher.trigger 'page:Change',
      page: page, opts: t

window.brahma.actions.page = module.exports = PageActions