React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

TextForm = React.createFactory require '../common/form/text'

{ div, form, a, button } = React.DOM

UserActions = require '../../actions/UserActions'

ObjectTools = require '../../util/objectTools'

module.exports = React.createClass

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

    form action: @props.action, onSubmit: @handleSubmit, className: cmpLoginF,
      @buildComp 'text', { label: username, name: 'login' }
      @buildComp 'password', { label: password, name: 'password' }
      @buildComp 'button', { label: login, }
      div {},
        a href: '/register',
          signup