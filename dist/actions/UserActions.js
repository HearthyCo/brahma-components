var AppDispatcher, UserActions;

AppDispatcher = require('../dispatcher/AppDispatcher');

UserActions = {
  login: function(user) {
    return AppDispatcher.trigger('user:login', {
      user: user
    });
  },
  register: function(user) {
    return AppDispatcher.trigger('user:register', {
      user: user
    });
  }
};

module.exports = UserActions;
