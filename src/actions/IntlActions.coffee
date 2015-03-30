AppDispatcher = require '../dispatcher/AppDispatcher'

IntlActions =
  requestChange: (locale) ->
    AppDispatcher.trigger 'intl:Change:request',
      locale: locale

module.exports = IntlActions