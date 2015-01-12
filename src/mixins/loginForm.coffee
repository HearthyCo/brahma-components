React = require 'react'
ReactIntl = require 'react-intl'

TextForm = React.createFactory require '../components/form/text'
ButtonForm = React.createFactory require '../components/form/button'

{ form, a } = React.DOM

UserActions = require '../actions/UserActions'

module.exports = React.createClass

  mixins: [ ReactIntl ]

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
    username = @getIntlMessage('username')
    password = @getIntlMessage('password')
    login = @getIntlMessage('login')

    form(
      action: @props.action
      onSubmit: @handleSubmit
      , @buildComp('text', { label: username, name: 'login' })
      , @buildComp('password', { label: password, name: 'password' })
      , @buildComp('button', { label: login, })
      , a(
        href: '/register'
        , 'Register'
      )
    )