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

  buildComp: (type, opt) ->
    switch type
      when 'text' then TextForm
        id: opt.name
        label: opt.label
        name: opt.name
        type: type

      when 'email' then TextForm
        id: opt.name
        label: opt.label
        name: opt.name
        type: type

      when 'password' then TextForm
        id: opt.name
        label: opt.label
        name: opt.name
        type: type

      when 'gender' then GenderForm
        id: opt.name
        label: opt.label
        name: opt.name

      when 'date' then DateForm
        id: opt.name
        label: opt.label
        name: opt.name

      when 'button' then ButtonForm
        id: opt.name
        label: opt.label


  render: ->
    # Mandatory fields: login, password, gender, name, birthdate
    form
      action: 'signup',
      onChange: @handleChange,
      onSubmit: @handleSubmit
      , @buildComp('text', { label: 'Username', name: 'login' })
      , @buildComp('email', { label: 'Email', name: 'email' })
      , @buildComp('password', { label: 'Password', name: 'password' })
      , @buildComp('password', { label: 'Repeat', name: 'password-repeat' })
      , @buildComp('text', { label: 'Name', name: 'name' })
      , @buildComp('gender', { label: 'Gender', name: 'gender' })
      , @buildComp('date', { label: 'Birthdate', name: 'birthdate' })
      , @buildComp('button', { label: 'Sign up', })
      , a(
        href: '/login'
        , 'Login'
      )