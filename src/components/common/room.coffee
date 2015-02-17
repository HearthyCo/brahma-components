React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

{ div, form, input, button, p } = React.DOM

module.exports = React.createClass

  displayName: 'room'

  mixins: [ReactIntl]

  getInitialState: ->
    messages: [ p {}, "Hola mundo!" ]

  handleMessage: (e) ->
    # TODO: This is fake, too.
    e.preventDefault()
    msgbox = this.refs.msgbox.getDOMNode()
    newMessage = msgbox.value.trim()
    msgbox.value = ''

    messages = @state.messages
    messages.push p {}, newMessage
    @setState messages

  render: ->
    div className: 'comp-room',
      div className: 'room-backlog',
        @state.messages
      form className: 'room-footer', onSubmit: @handleMessage,
        input
          className: 'room-input'
          placeholder: @getIntlMessage('type-here')
          ref: 'msgbox'
        button className: 'room-send', @getIntlMessage('send')