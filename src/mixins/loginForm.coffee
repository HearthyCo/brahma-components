React = require 'react'

TextForm = React.createFactory require "../components/form/text"
ButtonForm = React.createFactory require "../components/form/button"

{ form, a } = React.DOM

module.exports = React.createClass
  render: ->
    form(
      action: @props.action
      , TextForm(
        label: "Email",
        name: "login",
        type: "email"
      )
      , TextForm(
        label: "Password",
        name: "password",
        type: "password"
      ), ButtonForm(
        label: "Login"
      )
      , a(
        href: "/register"
        , "Register"
      )
    )