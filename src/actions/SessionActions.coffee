AppDispatcher = require '../dispatcher/AppDispatcher'
Utils = require '../util/actionsUtils'
Backbone = require 'exoskeleton'
PageActions = require './PageActions'
Queue = require '../util/queue'

urlUtils = require '../util/urlUtils'

SessionActions =
  create: (service) ->
    Utils.mkApiPoster '/session/create', service: service,
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
    Utils.mkApiPoster '/session/assignPool', serviceType: serviceType,
      'session', 'Assign', success: (response) ->
        console.log 'API POST Success:', response
        AppDispatcher.trigger  'session:Assign:success', response

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