###
  !!! DEPRECATED COMPONENT !!!
  Use sublistEntry with props.icon
###
React = require 'react'

SublistEntry = React.createFactory require './sublistEntry'

module.exports = React.createClass
  displayName: 'iconSublistEntry'
  render: ->
    SublistEntry @props