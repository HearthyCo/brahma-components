Backbone = require 'exoskeleton'
_ = require 'underscore'
AppDispatcher = require '../dispatcher/AppDispatcher'

ModalStore =
  content: false
  visible: false

_.extend ModalStore, Backbone.Events

ModalStore.addChangeListener = (callback) ->
  ModalStore.on 'change', callback

ModalStore.removeChangeListener = (callback) ->
  ModalStore.off 'change', callback

ModalStore.getModal = ->
  content: ModalStore.content
  visible: ModalStore.visible

AppDispatcher.on 'all', (eventName, payload) ->
  switch eventName
    when 'modal:Show'
      ModalStore.visible = true
      if payload.content
        ModalStore.content = payload.content
      ModalStore.trigger 'change'
    when 'modal:Hide'
      ModalStore.visible = false
      ModalStore.trigger 'change'

window.brahma.stores.modal = module.exports = ModalStore