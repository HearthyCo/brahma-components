React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

AlertStore = require '../../stores/AlertStore'
UserActions = require '../../actions/UserActions'

IconText = React.createFactory require '../common/form/iconText'
{ div, form, input, button, p } = React.DOM

module.exports = React.createClass

  displayName: 'requestPasswordChangeForm'

  mixins: [ReactIntl]

  getInitialState: (next) ->
    sent: if next then next.sent else false
    error: AlertStore.getFormAlert('RequestPasswordChange') or false

  componentWillReceiveProps: (next) ->
    @setState @getInitialState next

  handleSubmit: (e) ->
    e.preventDefault()

    obj = _.extend {}, @state

    @setState
      sent: true
      error: AlertStore.getFormAlert('RequestPasswordChange') or false

    UserActions.requestPasswordChange obj

  render: ->
    email = @getIntlMessage('email')
    send = @getIntlMessage('send')
    _className = 'comp-requestPasswordChangeForm'

    sendPass =
      label: email
      name: 'email'
      placeholder: email
      disabled: @state.blocked
      ref: 'mail'
      type: 'email'
      icon: 'email'

    if @state.error
      sendPass.error = ( @state.error.fields.indexOf(sendPass.name) > -1 )

    if @state.sent
      child = p {}, @getIntlMessage 'password-change-sent'
    else
      child = IconText sendPass

    form {
      action: @props.action or "post"
      onSubmit: @handleSubmit
      className: _className
    },
      child
      if @state.error
        div className: 'error-content',
          @getIntlMessage @state.error.content

      button disabled: @state.blocked, send
