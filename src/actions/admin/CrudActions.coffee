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

CrudActions = (returned, store, type) ->
  url = "#{store}"
  evt = capitalize(store)
  if type
    url = url + "/#{type}"
    evt = capitalize(type) + evt

  actions =
    create: (item) ->
      console.log "Create:", item
      Utils.mkApiPoster "#{url}/create", item,
        "#{returned}:", "#{evt}Create", success: (response) ->
          console.log "API POST Success:", response
          AppDispatcher.trigger  "#{returned}:successCreated", response
          PageActions.navigate "/crud#{url}/#{item.id}"

    read: (uid) ->
      console.log "Read:", uid
      Utils.mkApiGetter "/#{url}/#{uid}",
        "#{returned}:", "#{evt}Read", success()

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

    refresh: ->
      console.log "Refresh"
      Utils.mkApiGetter "/#{url}",
        "#{returned}s:", evt, success()

  return actions

module.exports = CrudActions
