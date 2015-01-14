React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

TextForm = React.createFactory require '../common/form/text'
DateForm = React.createFactory require '../common/form/date'
GenderForm = React.createFactory require '../common/form/gender'

{ div, form, a, button } = React.DOM

UserActions = require '../../actions/UserActions'

ObjectTools = require '../../util/objectTools'

module.exports = React.createClass

  mixins: [React.addons.LinkedStateMixin, ReactIntl]

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
    username = @getIntlMessage('username')
    email = @getIntlMessage('email')
    password = @getIntlMessage('password')
    repeat = @getIntlMessage('repeat')
    name = @getIntlMessage('name')
    gender = @getIntlMessage('gender')
    birthdate = @getIntlMessage('birthdate')
    signup = @getIntlMessage('signup')
    login = @getIntlMessage('login')

    cmpLoginF = 'comp-signupForm'

    # Mandatory fields: login, password, gender, name, birthdate
    form action: 'signup', onSubmit: @handleSubmit, className: cmpLoginF,
      @buildComp 'text', { label: username, name: 'login' }
      @buildComp 'email', { label: email, name: 'email' }
      @buildComp 'password', { label: password, name: 'password' }
      @buildComp 'password', { label: repeat, name: 'password-repeat' }
      @buildComp 'text', { label: name, name: 'name' }
      @buildComp 'gender', { label: gender, name: 'gender' }
      @buildComp 'date', { label: birthdate, name: 'birthdate' }
      @buildComp 'button', { label: signup, }
      div {},
        a href: '/login',
          login
