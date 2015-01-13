var Backbone, IntlActions, languages;

Backbone = require('exoskeleton');

languages = {
  'es-ES': '/locales/es-ES.json',
  'en-US': '/locales/en-US.json'
};

IntlActions = {
  translate: function(language, callback) {
    return Backbone.ajax({
      dataType: 'jsonp',
      url: languages[language],
      cache: true,
      success: function(response) {
        var messages;
        messages = {};
        messages[language] = response;
        return callback(language, messages);
      },
      error: function() {
        return console.log('ERROR');
      }
    });
  }
};

module.exports = IntlActions;
