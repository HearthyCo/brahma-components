React = require 'react'

TextForm = React.createFactory require "../components/form/text"
DateForm = React.createFactory require "../components/form/date"
GenderForm = React.createFactory require "../components/form/gender"
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
    form
      action: "signup",
      onChange: @handleChange,
      onSubmit: @handleSubmit
      , TextForm(
        label: "Username"
        name: "login"
        type: "text"
      )
      , TextForm(
        label: "Email"
        name: "email"
        type: "email"
      )
      , TextForm(
        label: "Password"
        name: "password"
        type: "password"
      )
      , TextForm(
        label: "Password repeat"
        type: "password"
      )
      , TextForm(
        label: "Name"
        name: "name"
        type: "text"
      )
      , GenderForm(
        label: "Gender"
        name: "gender"
        type: "text"
      )
      , DateForm(
        label: "Birthdate"
        name: "birthdate"
        type: "text"
      )
      , ButtonForm(
        label: "Sign up"
      )
      , a(
        href: "/login"
        , "Login"
      )
