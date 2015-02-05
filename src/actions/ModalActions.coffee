AppDispatcher = require '../dispatcher/AppDispatcher'

ModalActions =

  show: (content) ->
    AppDispatcher.trigger 'modal:show',
      content: content

  hide: (content) ->
    AppDispatcher.trigger 'modal:hide', {}


window.modal = ModalActions
module.exports = ModalActions