React = require 'react'

TextForm = React.createFactory require '../components/form/text'
ButtonForm = React.createFactory require '../components/form/button'

{ form, a } = React.DOM

UserActions = require '../actions/UserActions'

module.exports = React.createClass

  handleSubmit: (e) ->
    e.preventDefault()
    UserActions.login @getFormValue()

  getFormValue: ->
    ret = {}
    for i in @getDOMNode().elements
      if i.name
        ret[i.name] = i.value
    return ret

  buildComp: (type, opt) ->
    switch type
      when 'text' then TextForm
        id: opt.name
        label: opt.label
        name: opt.name
        type: type

      when 'password' then TextForm
        id: opt.name
        label: opt.label
        name: opt.name
        type: type

      when 'button' then ButtonForm
        id: opt.name
        label: opt.label

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