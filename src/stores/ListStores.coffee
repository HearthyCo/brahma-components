_ = require 'underscore'
Utils = require '../util/storeUtils'
EntityStores = require './EntityStores'
PageStore = require './PageStore'

# Stores for Lists of Entities

MixNewMessages = (data, current) ->
  messages = data.messages
  sessions = {}
  # Add new ones
  for message in messages
    session = message.session
    sessions[session] = true
    current[session] = [] if not current[session]
    pos = current[session].indexOf message.id
    if pos is -1
      current[message.session].push message.id
  # Sort them by timestamp
  # for session of sessions
  #   current[session].sort (a,b) ->
  #     ta = EntityStores.Message.get(a)?.timestamp
  #     tb = EntityStores.Message.get(b)?.timestamp
  #     ta - tb
  current

WithReset = (handler) -> (data, current) ->
  ret = handler.call @, data, current
  for key of current
    ret[key] = [] if not ret[key]
  ret

# pre-defined
Stores = {}

CheckLastViewed = (data, lastViewed) ->
  messages = data.messages
  messageSession = data.messages[0].session if messages? and messages.length

  if @currentSid is messageSession
    messages = Stores.Session.Messages.getIds(messageSession) or []
    length = messages.length
    lastViewed[messageSession] = [messages[length - 1]] if length
  lastViewed

Stores =
  SessionsByState:
    # Programmed: Utils.mkListStore EntityStores.Session,
    #   'sessions:ProgrammedSessions:success': (o) -> o.userSessions
    Underway: Utils.mkListStore EntityStores.Session,
      'sessions:UnderwaySessions:success': (o) -> o.userSessions
    Closed: Utils.mkListStore EntityStores.Session,
      'sessions:ClosedSessions:success': (o) -> o.userSessions

  UsersByType:
    Professional: Utils.mkListStore EntityStores.User,
      'users:ProfessionalUsers:success': (o) -> o.users

  ClientHome:
    Sessions:
      # Programmed: Utils.mkListStore EntityStores.Session,
      #   'clientHome:Home:success': (o) -> o.home.sessions.programmed
      Underway: Utils.mkListStore EntityStores.Session,
        'clientHome:Home:success': (o) -> o.home.sessions.underway
      Closed: Utils.mkListStore EntityStores.Session,
        'clientHome:Home:success': (o) -> o.home.sessions.closed
    Transactions: Utils.mkListStore EntityStores.Transaction,
      'clientHome:Home:success': (o) -> o.home.transactions

  Transactions: Utils.mkListStore EntityStores.Transaction,
    'transactions:UserTransactions:success': (o) -> o.userTransactions

  History:
    # Client-only, needs review
    Allergies: Utils.mkListStore EntityStores.HistoryEntry,
      'history:Allergies:success': (o) -> o.allergies

  User:
    History: Utils.mkSubListStore EntityStores.HistoryEntry,
      'session:Session:success': (o) -> o.userHistoryEntries
    Sessions: Utils.mkListStore EntityStores.Session,
      'sessions:Sessions:success': (o) -> o.userSessions

  UserSignatures: Utils.mkListStore EntityStores.SignedEntry,
    'user:Login:success': (o) -> o.sign.map (i) -> i.id
    'user:Signup:success': (o) -> o.sign.map (i) -> i.id
    'user:Me:success': (o) -> o.sign.map (i) -> i.id
    'session:Assign:success': (o) -> o.sign.map (i) -> i.id
    'session:Created:success': (o) -> o.sign.map (i) -> i.id
    'session:Booked:success': (o) -> o.sign.map (i) -> i.id

  Session:
    Participants: Utils.mkSubListStore EntityStores.SessionUser,
      'session:Session:success': (o) -> o.participants
    Messages: Utils.mkSubListStore EntityStores.Message,
      'chat:Received:success': MixNewMessages
      'chat:HistoryReceived:success': MixNewMessages
      'chat:Send:request': MixNewMessages
      'chat:SendFile:request': MixNewMessages
      'chat:SendFile:success': MixNewMessages
      'chat:SendFile:error': MixNewMessages
    LastViewedMessage: Utils.mkSubListStore EntityStores.Message, {
      'chat:ToggleVideo:open': ->
        @currentSid = 0
      'chat:ToggleVideo:close': (o, l) ->
        @currentSid = parseInt PageStore.getPage().opts.sessionId
        messages = Stores.Session.Messages.getIds(@currentSid) or []
        l[@currentSid] = [messages[messages.length - 1]] if messages.length
        l
      'page:Change': (o, l) ->
        pageName = o.page.displayName
        if pageName is 'roomPage' or pageName is 'sessionChatPage'
          @currentSid = parseInt o.opts.sessionId
          messages = Stores.Session.Messages.getIds(@currentSid) or []
          l[@currentSid] = [messages[messages.length - 1]] if messages.length
        else
          # prevent invalid currentId when page is not a chat page
          @currentSid = 0
        l
      'chat:Received:success': CheckLastViewed
      'chat:Send:request': CheckLastViewed
      }, storageKey: 'LastViewedMessage'

  ServiceTypes: Utils.mkListStore EntityStores.ServiceType,
    'serviceTypes:ServiceTypes:success': (o) ->
      o.allServiceTypes or o.servicetypes.map (st) -> st.id

  SessionsByServiceType: Utils.mkSubListStore EntityStores.Session,
    'serviceTypes:ServiceTypes:success': WithReset (o) -> o.serviceTypeSessions
    'session:Assign:success': WithReset (o) -> o.serviceTypeSessions
    'session:Finish:success': WithReset (o) -> o.serviceTypeSessions

### Client ###
# Home
Stores.ClientHome.getAll = -> Utils.treeEval Stores.ClientHome, 'getObjects', []

Stores.ClientHome.addChangeListener = (cb) ->
  Utils.treeEval Stores.ClientHome, 'addChangeListener', [cb]

Stores.ClientHome.removeChangeListener = (cb) ->
  Utils.treeEval Stores.ClientHome, 'removeChangeListener', [cb]

### Common ###
# Messages
Stores.Session.LastViewedMessage.getCounter = (sessionId) ->
  messages = Stores.Session.Messages.getIds(sessionId) or []
  lastViewed = Stores.Session.LastViewedMessage.getIds sessionId

  return 0 if not messages?
  return messages.length if not lastViewed?

  messages.length - messages.indexOf(lastViewed[0]) - 1

Stores.Session.Participants.getProfessional = (sessionId) ->
  sessionusers = Stores.Session.Participants.getObjects sessionId
  professionals = []
  if sessionusers
    users = sessionusers.map (o) -> EntityStores.User.get o.user
    professionals = users.filter (o) -> o.userType is 'professional'
  professionals

Stores.Session.hasUpdates = (sessionId) ->
  session = EntityStores.Session.get sessionId
  if session.state is 'UNDERWAY'
    messages = Stores.Session.Messages.getIds(sessionId) or []
    lastViewed = Stores.Session.LastViewedMessage.getIds sessionId

    return false if not messages? or not messages.length
    return true if not lastViewed?

    lastArrived = [messages[messages.length - 1]]

    return lastViewed[0] isnt lastArrived[0]
  else
    return false

window.brahma.stores.list = module.exports = Stores
