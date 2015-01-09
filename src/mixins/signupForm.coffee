React = require 'react'
_ = require 'underscore'

TextForm = React.createFactory require '../components/form/text'
DateForm = React.createFactory require '../components/form/date'
GenderForm = React.createFactory require '../components/form/gender'
ButtonForm = React.createFactory require '../components/form/button'

{ form, a } = React.DOM

UserActions = require '../actions/UserActions'

ObjectTools = require '../util/objectTools'

module.exports = React.createClass

  handleSubmit: (e) ->
    e.preventDefault()
    obj = _.extend {}, @state
    # Do your form post-processing here
    delete obj["password-repeat"]
    UserActions.register obj

  getInitialState: () ->
    return {}

  handleChange: (key, val) ->
    newState = _.extend {}, @state
    ObjectTools.indexStrSet newState, key, val
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
    # Mandatory fields: login, password, gender, name, birthdate
    form
      action: 'signup',
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