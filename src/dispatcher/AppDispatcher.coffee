_ = require 'underscore'
Backbone = require 'exoskeleton'

AppDispatcher = _.extend {}, Backbone.Events

module.exports = AppDispatcher