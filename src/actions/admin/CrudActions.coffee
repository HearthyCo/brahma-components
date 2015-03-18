AppDispatcher = require '../../dispatcher/AppDispatcher'
Utils = require '../../util/actionsUtils'

success = ->
  success: (response) ->
    @defaultOpts.success response

type = "professional"

CrudActions =
  create: (user) ->
    console.log 'Create:', user
    Utils.mkApiPoster "/users/#{type}/create", user: user,
      'user:', 'Create', success: (response) ->
        console.log 'API POST Success:', response
        AppDispatcher.trigger  'user:successCreated', response
        PageActions.navigate "/crud/#{type}/#{response.session.id}"

  update: (uid, user) ->
    console.log 'Update:', uid, user
    Utils.mkApiPoster "/users/#{type}/update/#{uid}", user: user,
      'user:', 'Update', success()

  delete: (uid) ->
    console.log 'Delete:', uid
    Utils.mkApiPoster "/users/#{type}/delete/#{uid}", {},
      'user:', 'Delete', success()

  ban: (uid) ->
    console.log 'Ban:', uid
    Utils.mkApiPoster "/users/#{type}/ban/#{uid}", {},
      'user:', 'Ban', success()

  read: (uid) ->
    console.log 'Read:', uid
    Utils.mkApiGetter "/users/#{type}/#{uid}",
      'user:', 'Read', success()

module.exports = CrudActions