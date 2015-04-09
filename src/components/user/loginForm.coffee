React = require 'react/addons'
ReactIntl = require '../../mixins/ReactIntl'
_ = require 'underscore'

AlertStore = require '../../stores/AlertStore'
UserActions = require '../../actions/UserActions'

IconTextForm = React.createFactory require '../common/form/iconText'
{ div, form, a, button, span } = React.DOM

module.exports = React.createClass

  displayName: 'loginForm'

  mixins: [React.addons.LinkedStateMixin, ReactIntl]

  propTypes:
    showRegister: React.PropTypes.bool

  handleSubmit: (e) ->
    e.preventDefault()
    obj = _.extend {}, @state
    # Do your form post-processing here
    UserActions.login obj

  getDefaultProps: () ->
    showRegister: true

  getInitialState: () ->
    return error: AlertStore.getFormAlert('UserLogin', 'error') or false

  componentWillReceiveProps: (next) ->
    @setState @getInitialState()

  buildComp: (type, opt) ->
    obj =
      id: opt.name
      label: opt.label
      icon: opt.icon
      name: opt.name
      type: type
      placeholder: opt.placeholder
      valueLink: @linkState opt.name
      error: false
      required: true

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
    login = @getIntlMessage 'login'
    signup = @getIntlMessage 'signup'

    _className = 'comp-loginForm'
    _className += ' error' if @state.error

    loginUser =
      label: email
      name: 'email'
      placeholder: email
      icon: 'email'

    loginPass =
      label: password
      name: 'password'
      placeholder: password
      icon: 'lock'

    form
      action: @props.action or "post"
      onSubmit: @handleSubmit
      className: _className,
      @buildComp 'email', loginUser
      @buildComp 'password', loginPass
      if @state.error
        div className: 'error-content',
          span className: 'icon icon-cross'
          span {},
            @getIntlMessage @state.error.content

      div className: 'forgotten-pass',
        a href: 'request/passwordChange',
          @getIntlMessage 'forgotten-password?'

      @buildComp 'button', label: login

      if @props.showRegister
        div className: 'create-account',
          span {}, @getIntlMessage 'do-not-have-account?'
          a href: '/register',
            signup