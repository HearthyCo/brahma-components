React = require 'react'

{div} = React.DOM

module.exports = React.createClass
  render: ->
    return (div { id: 'content' })