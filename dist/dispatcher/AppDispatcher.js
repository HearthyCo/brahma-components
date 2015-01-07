var AppDispatcher, Backbone, _;

_ = require('underscore');

Backbone = require('exoskeleton');

AppDispatcher = _.extend({}, Backbone.Events);

module.exports = AppDispatcher;
