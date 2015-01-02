React = require 'react'

InputForm = React.createFactory require "../components/form/input"
ButtonForm = React.createFactory require "../components/form/button"

{form} = React.DOM

module.exports = React.createClass
  render: ->
    return (form { action: @props.action },
      (InputForm { fieldName: "Email", type: "email" })
      (InputForm { fieldName: "Password", type: "password" })
      (ButtonForm { fieldName: "Login" })
    )