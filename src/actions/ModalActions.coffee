AppDispatcher = require '../dispatcher/AppDispatcher'

ModalActions =
  show: (content) ->
    AppDispatcher.trigger 'modal:Show',
      content: content

  hide: ->
    AppDispatcher.trigger 'modal:Hide', {}

window.brahma.actions.modal = module.exports = ModalActions