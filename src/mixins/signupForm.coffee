React = require 'react'
ReactIntlMixin = require 'react-intl'
_ = require 'underscore'

TextForm = React.createFactory require '../components/form/text'
DateForm = React.createFactory require '../components/form/date'
GenderForm = React.createFactory require '../components/form/gender'
ButtonForm = React.createFactory require '../components/form/button'

{ form, a } = React.DOM

UserActions = require '../actions/UserActions'

ObjectTools = require '../util/objectTools'

module.exports = React.createClass

  mixins: [ ReactIntlMixin ]

  handleSubmit: (e) ->
    e.preventDefault()
    obj = _.extend {}, @state
    birthdate = ("0000" + (obj.birthdate.year || "")).substr(-4) + '-'
    birthdate += ("00" + (obj.birthdate.month || "")).substr(-2) + '-'
    birthdate += ("00" + (obj.birthdate.day || "")).substr(-2)
    obj.birthdate = birthdate
    console.log obj
    UserActions.register obj

  getInitialState: () ->
    return {}

  handleChange: (key, val) ->
    newState = _.extend {}, @state
    ObjectTools.indexStrSet newState, key, val
    console.log 'New state:', newState
    @setState newState

  buildComp: (type, opt) ->
    switch type
      when 'text' then TextForm
        id: opt.name
        label: opt.label
        name: opt.name
        type: type
        callback: @handleChange
        value: @state[opt.name]

      when 'email' then TextForm
        id: opt.name
        label: opt.label
        name: opt.name
        type: type
        callback: @handleChange
        value: @state[opt.name]

      when 'password' then TextForm
        id: opt.name
        label: opt.label
        name: opt.name
        type: type
        callback: @handleChange
        value: @state[opt.name]

      when 'gender' then GenderForm
        id: opt.name
        label: opt.label
        name: opt.name
        callback: @handleChange
        value: @state[opt.name]

      when 'date' then DateForm
        id: opt.name
        label: opt.label
        name: opt.name
        callback: @handleChange
        value: @state[opt.name]

      when 'button' then ButtonForm
        id: opt.name
        label: opt.label


  render: ->

    username = @getIntlMessage('username')
    email = @getIntlMessage('email')
    password = @getIntlMessage('password')
    repeat = @getIntlMessage('repeat')
    name = @getIntlMessage('name')
    gender = @getIntlMessage('gender')
    birthdate = @getIntlMessage('birthdate')
    signup = @getIntlMessage('signup')

    # Mandatory fields: login, password, gender, name, birthdate
    form
      action: 'signup',
      onSubmit: @handleSubmit
      , @buildComp('text', { label: username, name: 'login' })
      , @buildComp('email', { label: email, name: 'email' })
      , @buildComp('password', { label: password, name: 'password' })
      , @buildComp('password', { label: repeat, name: 'password-repeat' })
      , @buildComp('text', { label: name, name: 'name' })
      , @buildComp('gender', { label: gender, name: 'gender' })
      , @buildComp('date', { label: birthdate, name: 'birthdate' })
      , @buildComp('button', { label: signup, })
      , a(
        href: '/login'
        , 'Login'
      )