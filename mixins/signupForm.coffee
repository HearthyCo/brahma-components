React = require 'react'

InputForm = require "./inputForm"
ButtonForm = require "./buttonForm"

{form} = React.DOM

module.exports = React.createClass
  render: ->
    return (form { action: "signup"}, [
      (InputForm { fieldName: "Username", type: "text" })
      (InputForm { fieldName: "Email", type: "email" })
      (InputForm { fieldName: "Password", type: "password" })
      (InputForm { fieldName: "Password repeat", type: "password" })
      (ButtonForm { fieldName: "Sign up" })
    ])