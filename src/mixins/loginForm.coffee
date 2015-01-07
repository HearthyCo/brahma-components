React = require 'react'

InputForm = React.createFactory require "../components/form/input"
ButtonForm = React.createFactory require "../components/form/button"

{form, a} = React.DOM

module.exports = React.createClass
  render: ->
    return (form { action: @props.action },
      (InputForm { label: "Email", name: "login", type: "email" })
      (InputForm { label: "Password", name: "password", type: "password" })
      (ButtonForm { label: "Login" })
      (a { href: "/register"}, "Register")
    )