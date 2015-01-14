Backbone = require 'exoskeleton'
_ = require 'underscore'

AppDispatcher = require '../dispatcher/AppDispatcher'
IntlActions = require '../actions/IntlActions'

conf =
  ext: '.json'
  dir: '/locales/'

getSourceUrl = (language) ->
  conf.dir + language + conf.ext


IntlStore =
  availableLocales: [ 'en-US', 'es-ES' ]
  locale: 'es-ES'
  messages:
    'es-ES': require '../../../brahma-client/app/intl/es-ES.json'

_.extend IntlStore, Backbone.Events


IntlStore.addChangeListener = (callback) ->
  IntlStore.on 'change', callback

IntlStore.removeChangeListener = (callback) ->
  IntlStore.off 'change', callback

loadTranslation = (language) ->
  Backbone.ajax
    dataType: 'jsonp'
    url: getSourceUrl language
    cache: true
    success: (response) ->
      console.log 'Downloaded and applied translation:', language
      IntlStore.messages[language] = response
      IntlStore.locale = language
      IntlStore.trigger 'change'
    error: (xhr, status) ->
      console.log 'Error loading translation:', status, xhr


AppDispatcher.on 'all', (eventName, payload) ->
  switch eventName
    when 'intl:requestChange'
      if IntlStore.messages[payload.locale]
        console.log 'Applied translation:', payload.locale
        IntlStore.locale = payload.locale
        IntlStore.trigger 'change'
      else
        loadTranslation payload.locale


module.exports = IntlStore