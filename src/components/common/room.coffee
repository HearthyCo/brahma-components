React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

{ div, form, input, button, p } = React.DOM

module.exports = React.createClass

  displayName: 'room'

  mixins: [ReactIntl]

  getInitialState: ->
    messages: [ p {}, "Hola mundo!" ]

  componentWillUpdate: ->
    node = @refs.log.getDOMNode()
    @shouldScroll = node.scrollTop + node.offsetHeight is node.scrollHeight

  componentDidUpdate: ->
    if @shouldScroll
      node = @refs.log.getDOMNode()
      node.scrollTop = node.scrollHeight

  handleMessage: (e) ->
    e.preventDefault()
    msgbox = @refs.msgbox.getDOMNode()
    newMessage = msgbox.value.trim()
    msgbox.value = ''
    # TODO: Really send it
    messages = @state.messages
    messages.push p {}, newMessage
    @setState messages

  render: ->
    div className: 'comp-room',
      div className: 'room-backlog', ref: 'log',
        @state.messages
      form className: 'room-footer', onSubmit: @handleMessage,
        input
          className: 'room-input'
          placeholder: @getIntlMessage('type-here')
          ref: 'msgbox'
        button className: 'room-send', @getIntlMessage('send')