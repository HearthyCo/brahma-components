AppDispatcher = require '../dispatcher/AppDispatcher'

ModalActions =
  show: (content) ->
    AppDispatcher.trigger 'modal:show',
      content: content

  hide: (content) ->
    AppDispatcher.trigger 'modal:hide', {}

window.brahma.actions.modal = module.exports = ModalActions