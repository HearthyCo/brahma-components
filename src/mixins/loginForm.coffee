React = require 'react/addons'
_ = require 'underscore'

TextForm = React.createFactory require '../components/form/text'

{ form, a, button } = React.DOM

UserActions = require '../actions/UserActions'

ObjectTools = require '../util/objectTools'

module.exports = React.createClass

  mixins: [React.addons.LinkedStateMixin]

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
    form(
      action: @props.action
      onSubmit: @handleSubmit
      , @buildComp('text', { label: 'Username', name: 'login' })
      , @buildComp('password', { label: 'Password', name: 'password' })
      , @buildComp('button', { label: 'Sign up', })
      , a(
        href: '/register'
        , 'Register'
      )
    )