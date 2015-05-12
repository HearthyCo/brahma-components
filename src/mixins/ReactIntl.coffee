###

Replaces the getIntlMessage function with a safer one that
doesn't crash the entire App when a string is missing.

Accepts a vars object to do Handlebars-like substitutions
###
ReactIntl = require 'react-intl'
_ = require 'underscore'

SafeIntl =
  getIntlMessage: (path, vars) ->
    str = ''
    try
      str = ReactIntl.getIntlMessage.call @, path
      # Like Handlebars
      if vars
        for k, v in vars
          str = str.replace "{{#{k}}}", v

    catch e
      console.warn "Warning! Intl string not found: #{arguments[0]}"
      str = "[intl:#{arguments[0]}]"

    return str

NewIntl = {}
_.extend NewIntl, ReactIntl, SafeIntl

module.exports = NewIntl