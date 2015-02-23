React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

IconTextForm = React.createFactory require '../common/form/iconText'

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
      icon: opt.icon
      name: opt.name
      type: type
      placeholder: opt.placeholder
      valueLink: @linkState opt.name

    switch type
      when 'email' then IconTextForm obj
      when 'password' then IconTextForm obj
      when 'button' then button
        id: opt.name
        , opt.label

  render: ->
    email = @getIntlMessage('email')
    password = @getIntlMessage('password')
    login = @getIntlMessage('login')
    signup = @getIntlMessage('signup')

    cmpLoginF = 'comp-loginForm'

    loginUser=
      label: email
      name: 'email'
      placeholder: email
      icon: 'email'

    loginPass=
       label: password
       name: 'password'
       placeholder: password
       icon: 'lock'

    form action: @props.action, onSubmit: @handleSubmit, className: cmpLoginF,
      @buildComp 'email', loginUser
      @buildComp 'password', loginPass
      div className: 'forgotten-pass',
        a href: '/register',
          @getIntlMessage('forgotten-password?')
      @buildComp 'button', label: login
      div className: 'create-account',
        span {}, @getIntlMessage('do-not-have-account?')
        a href: '/register',
          signup