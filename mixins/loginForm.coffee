React = require 'react'

InputForm = require "./inputForm"
ButtonForm = require "./buttonForm"

{form} = React.DOM

module.exports = React.createClass
  render: ->
    return (form { action: @props.action }, [
      (InputForm { fieldName: "Email", type: "email" })
      (InputForm { fieldName: "Password", type: "password" })
      (ButtonForm { fieldName: "Login" })
    ])