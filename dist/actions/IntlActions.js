var Backbone, IntlActions, conf, getSourceUrl;

Backbone = require('exoskeleton');

conf = {
  ext: '.json',
  dir: '/locales/'
};

getSourceUrl = function(language) {
  return conf.dir + language + conf.ext;
};

IntlActions = {
  translate: function(language, callback) {
    return Backbone.ajax({
      dataType: 'jsonp',
      url: getSourceUrl(language),
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
