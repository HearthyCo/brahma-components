React = require 'react'

TextForm = React.createFactory require "../components/form/text"
ButtonForm = React.createFactory require "../components/form/button"

{ form, a } = React.DOM

UserActions = require "../actions/UserActions"

module.exports = React.createClass

  handleSubmit: (e) ->
    e.preventDefault()
    UserActions.login @getFormValue()

  getFormValue: ->
    ret = {}
    for i in @getDOMNode().elements
      if i.name
        ret[i.name] = i.value
    return ret

  render: ->
    form(
      action: @props.action
      onSubmit: @handleSubmit
      , TextForm(
        label: "Username",
        name: "login",
        type: "text"
      )
      , TextForm(
        label: "Password",
        name: "password",
        type: "password"
      )
      , ButtonForm(
        label: "Login"
      )
      , a(
        href: "/register"
        , "Register"
      )
    )