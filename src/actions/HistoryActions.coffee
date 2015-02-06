AppDispatcher = require '../dispatcher/AppDispatcher'

HistoryActions =

  refresh: (section) ->
    AppDispatcher.trigger 'history:refresh',
      section: section


module.exports = HistoryActions