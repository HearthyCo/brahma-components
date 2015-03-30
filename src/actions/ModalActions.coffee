AppDispatcher = require '../dispatcher/AppDispatcher'

ModalActions =

  show: (content) ->
    AppDispatcher.trigger 'modal:Show',
      content: content

  hide: (content) ->
    AppDispatcher.trigger 'modal:Hide', {}


window.modal = ModalActions
module.exports = ModalActions