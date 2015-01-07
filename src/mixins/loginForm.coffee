React = require 'react'

InputForm = React.createFactory require "../components/form/input"
ButtonForm = React.createFactory require "../components/form/button"

{form, a} = React.DOM

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
    return (form { action: @props.action, onSubmit: @handleSubmit },
      (InputForm { label: "Username", name: "login", type: "text" })
      (InputForm { label: "Password", name: "password", type: "password" })
      (ButtonForm { label: "Login" })
      (a { href: "/register"}, "Register")
    )