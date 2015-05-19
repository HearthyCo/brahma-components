EntityStores = require '../stores/EntityStores'
ListStores = require '../stores/ListStores'
PageStore = require '../stores/PageStore'
SpinnerStore = require '../stores/SpinnerStore'

Utils = require '../util/frontendUtils'

ChatActions = require '../actions/ChatActions'
PageActions = require '../actions/PageActions'

# It binds once
bindOnce = (store, evnt, callbackFn) ->
  callback = () ->
    callbackFn()
    store.unbind evnt, callback
  store.bind evnt, callback

execNativeVideo = (sessionId, participants) -> ->
  if not participants?
    participants = ListStores.Session.Participants.getObjects sessionId

  session = EntityStores.Session.get sessionId
  tokBoxSession = session.meta.opentokSession
  tokBoxToken = participants[0].meta.opentokToken
  window.AppInterface.startNativeVideo tokBoxSession, tokBoxToken

execUpdateToolbar = (sessionId) -> ->
  professionals = ListStores.Session.Participants.getProfessional sessionId
  professional = professionals[0]

  if professional?
    name = professional.name if professional.name?
    name += ' ' + professional.surname1 if name? and professional.surname1
    name = professional.email if not name?
    id = professional.id if professional.id?
    avatar = professional.avatar if professional.avatar?

    window.AppInterface.updateChatToolbar name, id, avatar

AppUtils =
  back: ->
    pageBackObject = PageStore.goBack()

    if not pageBackObject?
      window.AppInterface.closeApp()

  # Buy with paypal
  paypalBuy: (data) -> window.AppInterface.paypalBuy data.amount

  # Pick a file to send to chat
  pickFile: ->
    Utils.pickFile (e) ->
      for file in e.target.files
        session = PageStore.getPage().opts.sessionId
        user = EntityStores.User.get EntityStores.User.currentUid
        ChatActions.sendFile session, file, user if session? and user?

  # Navigate to professional profile
  goProfessionalProfile: (professionalId) ->
    sessionId = PageStore.getPage().opts?.sessionId
    if sessionId
      PageActions.navigate '/session/' + sessionId + '/user/' + professionalId

  # Start native video on video session
  startNativeVideo: ->
    pageObject = PageStore.getPage()
    current = pageObject.current.displayName
    if current is 'sessionVideoPage'
      sessionId = pageObject.opts.sessionId
      participants = ListStores.Session.Participants.getObjects sessionId

      if participants?
        execNativeVideo(sessionId, participants)()
      else
        bindOnce ListStores.Session.Participants, 'change',
          execNativeVideo sessionId

  # Update chat toolbar when participants change
  updateChatToolbar: ->
    pageObject = PageStore.getPage()
    current = pageObject.current.displayName
    if current is 'sessionVideoPage' or current is 'sessionChatPage'
      sessionId = pageObject.opts.sessionId
      participants = ListStores.Session.Participants.getObjects sessionId

      if participants?
        execUpdateToolbar(sessionId)()
      else
        bindOnce EntityStores.SessionUser, 'change', execUpdateToolbar sessionId

  updateCurrentPage: ->
    displayName = PageStore.getPage().current.displayName
    user = EntityStores.User.get EntityStores.User.currentUid
    isValidUser = user?.name?
    window.AppInterface.updateCurrentPage displayName, isValidUser

  # Potential user change
  updateUid: ->
    window.AppInterface.updateUid EntityStores.User.currentUid

  setLoadingStatus: ->
    window.AppInterface.setLoadingStatus SpinnerStore.showSpinner()

  sessionChange: (pl) ->
    # If we are on a video page of a session, and it is now closed, kill video
    pageObject = PageStore.getPage()
    current = pageObject.current.displayName
    if current is 'sessionVideoPage' or current is 'sessionChatPage'
      sessionId = pageObject.opts.sessionId
      if EntityStores.Session.get(sessionId)?.state in ['CLOSED', 'FINISHED']
        window.AppInterface.videoSessionEnd sessionId

window.brahma.utils.app = module.exports = AppUtils