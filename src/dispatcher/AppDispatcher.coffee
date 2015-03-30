_ = require 'underscore'
Backbone = require 'exoskeleton'

AppDispatcher = _.extend {}, Backbone.Events

window.brahma.dispatcher = module.exports = AppDispatcher