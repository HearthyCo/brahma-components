###
Crud endpoints and events have a common structure.

They are defined by three values:

- returned type
- store used
- type or filter (optional)

In example:
- returned type: user
- store used: users
- type or filter: profesional



###

AppDispatcher = require "../../dispatcher/AppDispatcher"
Utils = require "../../util/actionsUtils"

capitalize = (string) ->
  string.charAt(0).toUpperCase() + string.slice(1)

success = ->
  success: (response) ->
    @defaultOpts.success response

returned = null
store = null
type  = null
url = null
evt = null

CrudActions =
  config: (_returned, _store, _type) ->
    returned = _returned
    store = _store
    type = _type

    url = "#{store}"
    evt = capitalize(store)
    if type
      url = url + "/#{type}"
      evt = capitalize(type) + evt

  create: (user) ->
    console.log "Create:", user
    Utils.mkApiPoster "#{url}/create", user,
      "#{returned}:", "#{evt}Create", success: (response) ->
        console.log "API POST Success:", response
        AppDispatcher.trigger  "#{returned}:successCreated", response
        PageActions.navigate "/crud#{url}/#{user.id}"

  update: (item) ->
    console.log "Update:", item
    Utils.mkApiPoster "/#{url}/update/#{item.id}", item,
      "#{returned}:", "#{evt}Update", success()

  delete: (uid) ->
    console.log "Delete:", uid
    Utils.mkApiPoster "/#{url}/delete/#{uid}", {},
      "#{returned}:", "#{evt}Delete", success()

  ban: (uid) ->
    console.log "Ban:", uid
    Utils.mkApiPoster "/#{url}/ban/#{uid}", {},
      "#{returned}:", "#{evt}Ban", success()

  read: (uid) ->
    console.log "Read:", uid
    Utils.mkApiGetter "/#{url}/#{uid}",
      "#{returned}:", "#{evt}Read", success()

  refresh: ->
    console.log "Refresh"
    Utils.mkApiGetter "/#{url}",
      "#{returned}s:", evt, success()

module.exports = CrudActions