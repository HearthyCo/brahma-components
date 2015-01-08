React = require 'react'

TextForm = React.createFactory require '../components/form/text'
DateForm = React.createFactory require '../components/form/date'
GenderForm = React.createFactory require '../components/form/gender'
ButtonForm = React.createFactory require '../components/form/button'

{ form, a } = React.DOM

UserActions = require '../actions/UserActions'

module.exports = React.createClass

  handleSubmit: (e) ->
    e.preventDefault()
    #console.log @getFormValue()
    UserActions.register @getFormValue()

  handleChange: (e) ->
    #console.log @getFormValue()

  getFormValue: ->
    ret = {}
    bdate = {}

    for i in @getDOMNode().elements
      if i.name
        if i.type == 'radio'
          if i.checked
            ret[i.name] = i.value
        else if i.nodeName == 'SELECT'
          bdate[i.name] = (if i.value < 10 then 0 + i.value else i.value)
        else
          ret[i.name] = i.value

    ret['birthdate'] = bdate.year + '-' + bdate.month + '-' + bdate.day
    return ret

  render: ->
    # Mandatory fields: login, password, gender, name, birthdate
    form
      action: 'signup',
      onChange: @handleChange,
      onSubmit: @handleSubmit
      , TextForm(
        id: 'username'
        label: 'Username'
        name: 'login'
        type: 'text'
      )
      , TextForm(
        id: 'email'
        label: 'Email'
        name: 'email'
        type: 'email'
      )
      , TextForm(
        id: 'password'
        label: 'Password'
        name: 'password'
        type: 'password'
      )
      , TextForm(
        id: 'password-repeat'
        label: 'Password repeat'
        type: 'password'
      )
      , TextForm(
        id: 'name'
        label: 'Name'
        name: 'name'
        type: 'text'
      )
      , GenderForm(
        id: 'gender'
        label: 'Gender'
        name: 'gender'
      )
      , DateForm(
        id: 'birthdate'
        label: 'Birthdate'
        name: 'birthdate'
      )
      , ButtonForm(
        id: 'signup'
        label: 'Sign up'
      )
      , a(
        href: '/login'
        , 'Login'
      )
