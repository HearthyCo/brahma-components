React = require 'react'
_ = require 'underscore'

TextForm = React.createFactory require '../components/form/text'
ButtonForm = React.createFactory require '../components/form/button'

{ form, a } = React.DOM

UserActions = require '../actions/UserActions'

ObjectTools = require '../util/objectTools'

module.exports = React.createClass

  handleSubmit: (e) ->
    e.preventDefault()
    obj = _.extend {}, @state
    # Do your form post-processing here
    UserActions.login obj

  getInitialState: () ->
    return {}

  handleChange: (key, val) ->
    newState = _.extend {}, @state
    ObjectTools.indexStrSet newState, key, val
    @setState newState

  buildComp: (type, opt) ->
    switch type
      when 'text' then TextForm
        id: opt.name
        label: opt.label
        name: opt.name
        type: type
        callback: @handleChange
        value: @state[opt.name]

      when 'password' then TextForm
        id: opt.name
        label: opt.label
        name: opt.name
        type: type
        callback: @handleChange
        value: @state[opt.name]

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