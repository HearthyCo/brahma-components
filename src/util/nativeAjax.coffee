# CORS OVERRIDE

_ = require 'underscore'

# Sends credentials
nativeajax = require 'backbone.nativeajax'

ajax = (opts) ->

  defaults =
    type: 'GET'
    dataType: 'json'
    xhrFields:
      withCredentials: true
    headers:
      'X-Requested-With': 'XMLHttpRequest'

  # Save beforeSend callback if present
  _beforeSend = opts.beforeSend or null

  # Apply default values
  opts = _.defaults opts, defaults

  opts.beforeSend = (xhr) ->
    # Apply xhrFields if present
    if opts.xhrFields
      xhr[field] = value for field, value of opts.xhrFields
    # callback?
    xhr = _beforeSend xhr if _beforeSend
    return xhr

  arguments[0] = opts
  nativeajax.apply nativeajax, arguments

module.exports = ajax