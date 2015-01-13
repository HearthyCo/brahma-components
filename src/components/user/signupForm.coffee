React = require 'react/addons'
_ = require 'underscore'

TextForm = React.createFactory require '../common/form/text'
DateForm = React.createFactory require '../common/form/date'
GenderForm = React.createFactory require '../common/form/gender'

{ form, a, button } = React.DOM

UserActions = require '../../actions/UserActions'

ObjectTools = require '../../util/objectTools'

module.exports = React.createClass

  mixins: [React.addons.LinkedStateMixin]

  handleSubmit: (e) ->
    e.preventDefault()
    obj = _.extend {}, @state
    # Do your form post-processing here
    delete obj["password-repeat"]
    UserActions.register obj

  getInitialState: () ->
    return {}

  buildComp: (type, opt) ->
    obj =
      id: opt.name
      label: opt.label
      name: opt.name
      type: type
      valueLink: @linkState opt.name

    switch type
      when 'text' then TextForm obj
      when 'email' then TextForm obj
      when 'password' then TextForm obj
      when 'gender' then GenderForm obj
      when 'date' then DateForm obj
      when 'button' then button
        id: opt.name
        , opt.label


  render: ->
    # Mandatory fields: login, password, gender, name, birthdate
    form action: 'signup', onSubmit: @handleSubmit, className: 'comp-signupForm',
      @buildComp 'text', { label: 'Username', name: 'login' }
      @buildComp 'email', { label: 'Email', name: 'email' }
      @buildComp 'password', { label: 'Password', name: 'password' }
      @buildComp 'password', { label: 'Repeat', name: 'password-repeat' }
      @buildComp 'text', { label: 'Name', name: 'name' }
      @buildComp 'gender', { label: 'Gender', name: 'gender' }
      @buildComp 'date', { label: 'Birthdate', name: 'birthdate' }
      @buildComp 'button', { label: 'Sign up', }
      a href: '/login',
        'Login'
