###

Replaces the getIntlMessage function with a safer one that
doesn't crash the entire App when a string is missing.

###
ReactIntl = require 'react-intl'
_ = require 'underscore'

SafeIntl =
  getIntlMessage: (path) ->
    try
      return ReactIntl.getIntlMessage.call @, path
    catch e
      console.error "Error: Intl string not found: #{arguments[0]}"
      return "[intl:#{arguments[0]}]"

NewIntl = {}
_.extend NewIntl, ReactIntl, SafeIntl

module.exports = NewIntl