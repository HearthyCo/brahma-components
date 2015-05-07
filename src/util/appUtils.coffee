EntityStores = require '../stores/EntityStores'
ListStores = require '../stores/ListStores'
PageStore = require '../stores/PageStore'

Utils = require '../util/frontendUtils'

ChatActions = require '../actions/ChatActions'
PageActions = require '../actions/PageActions'

AppInterface = window.AppInterface

mkBind = (store, evnt, callbackFn) ->
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
  AppInterface.startNativeVideo tokBoxSession, tokBoxToken

execUpdateToolbar = (sessionId, participants) -> ->
  if not participants?
    participants = ListStores.Session.Participants.getObjects sessionId
  if participants.length
    users = participants.map (userObj) -> EntityStores.User.get userObj.user
    professionals = users.filter (userObj) -> userObj.userType is 'professional'
    professional = professionals[0] if professionals.length
    if professional?
      name = professional.name if professional.name?
      name += ' ' + professional.surname1 if name?
      name = professional.email if not name?
      id = professional.id if professional.id?
      avatar = professional.avatar if professional.avatar?

      AppInterface.updateChatToolbar name, id, avatar

AppUtils =
  back: ->
    pageBackObject = PageStore.goBack()

    if not pageBackObject?
      AppInterface.closeApp()

  paypalBuy: (data) -> AppInterface.paypalBuy data.amount

  pickFile: ->
    Utils.pickFile (e) ->
      for file in e.target.files
        session = PageStore.getPage().opts.sessionId
        user = EntityStores.User.get EntityStores.User.currentUid
        ChatActions.sendFile session, file, user if session? and user?

  goProfessionalProfile: (professionalId) ->
    sessionId = PageStore.getPage().opts?.sessionId
    if sessionId
      PageActions.navigate '/session/' + sessionId + '/user/' + professionalId

  startNativeVideo: ->
    pageObject = PageStore.getPage()
    current = pageObject.current.displayName
    if current is 'sessionVideoPage'
      sessionId = pageObject.opts.sessionId
      participants = ListStores.Session.Participants.getObjects sessionId

      if participants?
        execNativeVideo(sessionId, participants)()
      else
        mkBind ListStores.Session.Participants, 'change',
          execNativeVideo sessionId

  updateChatToolbar: ->
    pageObject = PageStore.getPage()
    current = pageObject.current.displayName
    if current is 'sessionVideoPage' or current is 'sessionChatPage'
      sessionId = pageObject.opts.sessionId
      participants = ListStores.Session.Participants.getObjects sessionId

      if participants?
        execUpdateToolbar(sessionId, participants)()
      else
        mkBind EntityStores.SessionUser, 'change', execUpdateToolbar sessionId

  updateCurrentPage: ->
    AppInterface.updateCurrentPage PageStore.getPage().current.displayName

window.brahma.utils.app = module.exports = AppUtils