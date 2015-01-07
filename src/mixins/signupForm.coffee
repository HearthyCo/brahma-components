React = require 'react'

InputForm = React.createFactory require "../components/form/input"
ButtonForm = React.createFactory require "../components/form/button"

{form, a} = React.DOM

UserActions = require "../actions/UserActions"

module.exports = React.createClass

  handleSubmit: (e) ->
    e.preventDefault()
    #console.log @getFormValue()
    UserActions.register @getFormValue()

  handleChange: (e) ->
    #console.log @getFormValue()

  getFormValue: ->
    ret = {}
    for i in @getDOMNode().elements
      if i.name
        ret[i.name] = i.value
    return ret

  render: ->
    # Mandatory fields: login, password, gender, name, birthdate
    return (form { action: "signup", onChange: @handleChange, onSubmit: @handleSubmit },
      (InputForm { label: "Username", name: "login", type: "text" })
      (InputForm { label: "Email", name: "email", type: "email" })
      (InputForm { label: "Password", name: "password",type: "password" })
      (InputForm { label: "Password repeat", type: "password" })
      (InputForm { label: "Name", name: "name", type: "text" })
      (InputForm { label: "Gender", name: "gender", type: "text" })
      (InputForm { label: "Birthdate", name: "birthdate", type: "text" })
      (ButtonForm { label: "Sign up" })
      (a { href: "/login"}, "Login")
    )