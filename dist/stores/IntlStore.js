var AppDispatcher, Backbone, IntlActions, IntlStore, conf, getSourceUrl, loadTranslation, _;

Backbone = require('exoskeleton');

_ = require('underscore');

AppDispatcher = require('../dispatcher/AppDispatcher');

IntlActions = require('../actions/IntlActions');

conf = {
  ext: '.json',
  dir: '/locales/'
};

getSourceUrl = function(language) {
  return conf.dir + language + conf.ext;
};

IntlStore = {
  availableLocales: ['en-US', 'es-ES'],
  locale: 'es-ES',
  messages: {
    'es-ES': require('../../../brahma-client/app/intl/es-ES.json')
  }
};

_.extend(IntlStore, Backbone.Events);

IntlStore.addChangeListener = function(callback) {
  return IntlStore.on('change', callback);
};

IntlStore.removeChangeListener = function(callback) {
  return IntlStore.off('change', callback);
};

loadTranslation = function(language) {
  return Backbone.ajax({
    dataType: 'jsonp',
    url: getSourceUrl(language),
    cache: true,
    success: function(response) {
      console.log('Downloaded and applied translation:', language);
      IntlStore.messages[language] = response;
      IntlStore.locale = language;
      return IntlStore.trigger('change');
    },
    error: function(xhr, status) {
      return console.log('Error loading translation:', status, xhr);
    }
  });
};

AppDispatcher.on('all', function(eventName, payload) {
  switch (eventName) {
    case 'intl:requestChange':
      if (IntlStore.messages[payload.locale]) {
        console.log('Applied translation:', payload.locale);
        IntlStore.locale = payload.locale;
        return IntlStore.trigger('change');
      } else {
        return loadTranslation(payload.locale);
      }
  }
});

module.exports = IntlStore;
