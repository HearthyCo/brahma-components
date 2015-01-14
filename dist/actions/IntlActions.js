var AppDispatcher, IntlActions;

AppDispatcher = require('../dispatcher/AppDispatcher');

IntlActions = {
  requestChange: function(locale) {
    return AppDispatcher.trigger('intl:requestChange', {
      locale: locale
    });
  }
};

module.exports = IntlActions;
