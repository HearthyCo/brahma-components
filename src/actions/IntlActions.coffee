AppDispatcher = require '../dispatcher/AppDispatcher'

IntlActions =

  requestChange: (locale) ->
    AppDispatcher.trigger 'intl:requestChange',
      locale: locale


module.exports = IntlActions