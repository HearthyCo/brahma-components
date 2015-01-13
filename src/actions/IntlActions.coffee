Backbone = require 'exoskeleton'

languages = {
  'es-ES': '/locales/es-ES.json'
  'en-US': '/locales/en-US.json'
}

IntlActions = {

  translate: (language, callback) ->
    Backbone.ajax
      dataType: 'jsonp'
      url: languages[language]
      cache: true
      success: (response) ->
        messages = {}
        messages[language] = response

        callback language, messages
      error: () ->
        console.log 'ERROR'
}

module.exports = IntlActions