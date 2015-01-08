var AppDispatcher, Backbone, UserStore;

Backbone = require('exoskeleton');

AppDispatcher = require('../dispatcher/AppDispatcher');

UserStore = Backbone.Model.extend({
  urlRoot: '/v1/user',
  defaults: {
    type: 'CLIENT'
  }
});

AppDispatcher.on('all', function(eventName, payload) {
  var user;
  switch (eventName) {
    case 'user:register':
      user = new UserStore();
      return user.save(payload.user, {
        success: function(model, response) {
          return console.log('Register success!', model, response);
        },
        error: function(model, response) {
          return console.log('Error registering!', model, response);
        }
      });
    case 'user:login':
      user = new UserStore();
      return user.save(payload.user, {
        url: '/v1/user/login',
        success: function(model, response) {
          return console.log('Login success!', model, response);
        },
        error: function(model, response) {
          return console.log('Login error!', model, response);
        }
      });
  }
});

module.exports = UserStore;