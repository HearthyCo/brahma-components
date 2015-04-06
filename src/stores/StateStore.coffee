_ = require 'underscore'
Utils = require '../util/storeUtils'


window.brahma.stores.state = module.exports =

  ChatTabs:
    inputs: Utils.mkStateStore()