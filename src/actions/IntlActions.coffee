Backbone = require 'exoskeleton'

conf =
  ext: '.json'
  dir: '/locales/'

getSourceUrl = (language) ->
  conf.dir + language + conf.ext

IntlActions =
  translate: (language, callback) ->
    Backbone.ajax
      dataType: 'jsonp'
      url: getSourceUrl language
      cache: true
      success: (response) ->
        messages = {}
        messages[language] = response
        callback language, messages
      error: () ->
        console.log 'ERROR'

module.exports = IntlActions