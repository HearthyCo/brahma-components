React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

IconTextForm = React.createFactory require '../common/form/iconText'
DateForm = React.createFactory require '../common/form/date'
GenderForm = React.createFactory require '../common/form/gender'

{ div, form, a, button, span } = React.DOM

UserActions = require '../../actions/UserActions'
AlertStore = require '../../stores/AlertStore'

ObjectTools = require '../../util/objectTools'

module.exports = React.createClass

  displayName: 'signupForm'

  mixins: [React.addons.LinkedStateMixin, ReactIntl]

  handleSubmit: (e) ->
    e.preventDefault()
    obj = _.extend {}, @state
    # Do your form post-processing here
    delete obj["password-repeat"]
    UserActions.register obj

  getInitialState: () ->
    return error: AlertStore.getFormAlert('UserRegister') || false

  componentWillReceiveProps: (next) ->
    @setState @getInitialState()

  buildComp: (type, opt) ->
    obj =
      id: opt.name
      label: opt.label
      name: opt.name
      icon: opt.icon
      type: type
      placeholder: opt.placeholder
      valueLink: @linkState opt.name

    if @state.error
      obj.error = ( @state.error.fields.indexOf(opt.name) > -1 )

    switch type
      when 'email' then IconTextForm obj
      when 'password' then IconTextForm obj
      when 'button' then button
        id: opt.name
        , opt.label

  render: ->
    email = @getIntlMessage 'email'
    password = @getIntlMessage 'password'
    signup = @getIntlMessage 'signup'
    login = @getIntlMessage 'login'

    cmpLoginF = 'comp-signupForm'

    signupUser=
      label: email
      name: 'email'
      placeholder: email
      icon: 'email'

    signupPass=
       label: password
       name: 'password'
       placeholder: password
       icon: 'lock'

    # Mandatory fields: login, password, gender, name, birthdate
    form action: 'signup', onSubmit: @handleSubmit, className: cmpLoginF,
      @buildComp 'email', signupUser
      @buildComp 'password', signupPass
      if @state.error
        div className: 'error-content',
          @getIntlMessage @state.error.content

      @buildComp 'button', label: signup

      div className: 'start-session',
        span {}, @getIntlMessage 'i-have-account'
        a href: '/login',
          login
