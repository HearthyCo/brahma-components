_ = require 'underscore'
Utils = require '../util/storeUtils'


window.brahma.stores.state = module.exports =

  chatTabs:
    inputs: Utils.mkStateStore()
    reports: Utils.mkStateStore default: ''
    openSections: Utils.mkStateStore()
