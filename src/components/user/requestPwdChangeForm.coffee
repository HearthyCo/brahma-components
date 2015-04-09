React = require 'react/addons'
ReactIntl = require '../../mixins/ReactIntl'
_ = require 'underscore'

AlertStore = require '../../stores/AlertStore'
UserActions = require '../../actions/UserActions'

IconText = React.createFactory require '../common/form/iconText'
{ div, form, input, button, p } = React.DOM

module.exports = React.createClass

  displayName: 'requestPasswordChangeForm'

  mixins: [ReactIntl]

  getInitialState: (next) ->
    newState = {}
    # Set an initial error state
    if not next or not next.hasOwnProperty 'error'
      newState.error = AlertStore.getFormAlert(
        'UserRequestPasswordChange',
        'error'
      ) or false
    else
      newState.error = next.error

    # On error, retry is allowed
    if newState.error
      newState.sent = false
    else
      newState.sent = if next then next.sent else false

    return newState

  componentWillReceiveProps: (next) ->
    @setState @getInitialState next

  handleSubmit: (e) ->
    e.preventDefault()

    obj = _.extend {}, @state

    @setState
      sent: true
      error: false

    UserActions.requestPasswordChange obj

  render: ->
    email = @getIntlMessage('email')
    send = @getIntlMessage('send')
    _className = 'comp-requestPasswordChangeForm'

    sendPass =
      label: email
      name: 'email'
      placeholder: email
      ref: 'mail'
      type: 'email'
      icon: 'email'
      required: true

    if @state.error
      sendPass.error = ( @state.error.fields.indexOf(sendPass.name) > -1 )
      _className += ' error'

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

      button disabled: @state.sent, send
