_ = require 'underscore'
AppDispatcher = require '../dispatcher/AppDispatcher'
Utils = require '../util/actionsUtils'
Backbone = require 'exoskeleton'
PageActions = require './PageActions'

AlertActions = require './AlertActions'

ListStores = require '../stores/ListStores'

urlUtils = require '../util/urlUtils'

SessionActions =

  create: (service) ->
    # Before really creating the session, redirect the user to the form
    PageActions.navigate '/session/new/' + service + '/form'

  realCreate: (service, meta) ->
    payload = service: service
    payload.meta = meta if meta
    Utils.mkApiPoster '/session/create', payload,
      'session', 'Created', success: (response) ->
        console.log 'API POST Success:', response
        AppDispatcher.trigger  'session:Created:success', response

        link = urlUtils.getUrl.session response.session
        PageActions.navigate link

  # TODO: check if it works
  book: (service, startDate) ->
    Utils.mkApiPoster '/session/book',
      { service: service, startDate: startDate }, 'session', 'Booked',
      success: (response) ->
        console.log 'API POST Success:', response
        AppDispatcher.trigger  'session:Booked:success', response
        PageActions.navigate '/session/' + response.session.id

  assign: (serviceType) ->
    oldIds = ListStores.SessionsByServiceType.getIds serviceType
    Utils.mkApiPoster '/session/assignPool', serviceType: serviceType,
      'session', 'Assign',
      success: (response) ->
        console.log 'API POST Success:', response
        AppDispatcher.trigger  'session:Assign:success', response
        newIds = ListStores.SessionsByServiceType.getIds serviceType
        diff = _.difference newIds, oldIds
        if diff.length
          PageActions.navigate '/session/' + diff[0]
      error: (xhr) ->
        alert = id: 'alert-session_Assign', level: 'error'
        if xhr.response.indexOf('No pending') isnt -1
          alert.intl = 'alert-session_Assign-pending'
        else if xhr.response.indexOf('too many') isnt -1
          alert.intl = 'alert-session_Assign-many'
        else return # Leave the default one
        AlertActions.show alert

  refresh: (target) ->
    Utils.mkApiGetter '/session/' + target, 'session', 'Session'

  refreshMessages: (target) ->
    Utils.mkApiGetter '/session/' + target, 'session', 'Session' # DEBUG

  getByServiceType: ->
    Utils.mkApiGetter '/sessions/assigned', 'serviceTypes', 'ServiceTypes'

  updateReport: (target, report) ->
    Utils.mkApiPoster '/sessionuser/' + target + '/report', report: report,
      'session', 'UpdateReport'

  close: (target) ->
    Utils.mkApiPoster '/session/' + target + '/close', {}, 'session', 'Close'

  finish: (target) ->
    Utils.mkApiPoster '/session/' + target + '/finish', {}, 'session', 'Finish'


module.exports = SessionActions