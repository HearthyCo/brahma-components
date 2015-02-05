React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

TextForm = React.createFactory require '../common/form/text'

{ div, form, a, button, span } = React.DOM

UserActions = require '../../actions/UserActions'

ObjectTools = require '../../util/objectTools'

module.exports = React.createClass

  displayName: 'loginForm'

  mixins: [React.addons.LinkedStateMixin, ReactIntl]

  handleSubmit: (e) ->
    e.preventDefault()
    obj = _.extend {}, @state
    # Do your form post-processing here
    UserActions.login obj

  getInitialState: () ->
    return {}

  buildComp: (type, opt) ->
    obj =
      id: opt.name
      label: opt.label
      name: opt.name
      type: type
      placeholder: opt.placeholder
      valueLink: @linkState opt.name

    switch type
      when 'text' then TextForm obj
      when 'password' then TextForm obj
      when 'button' then button
        id: opt.name
        , opt.label

  render: ->
    username = @getIntlMessage('username')
    password = @getIntlMessage('password')
    login = @getIntlMessage('login')
    signup = @getIntlMessage('signup')

    cmpLoginF = 'comp-loginForm'

    loginUser=
      label: username
      name: 'login'
      placeholder: username

    loginPass=
       label: password
       name: 'password'
       placeholder: password

    form action: @props.action, onSubmit: @handleSubmit, className: cmpLoginF,
      @buildComp 'text', loginUser
      @buildComp 'password', loginPass
      div className: 'forgotten-pass',
        a href: '/register',
          'Forgotten password?'
      @buildComp 'button', { label: login, }
      div className: 'create-account',
        span: 'Do not have account?'
        a href: '/register',
          signup