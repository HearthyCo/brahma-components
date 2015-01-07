var AppDispatcher, Backbone, UserStore;

Backbone = require('exoskeleton');

AppDispatcher = require('../dispatcher/AppDispatcher');

UserStore = Backbone.Model.extend({
  urlRoot: '/v1/user',
  defaults: {
    type: 'CLIENT'
  }
});

module.exports = UserStore;
