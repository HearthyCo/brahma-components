React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

{ div, form, input, button, p } = React.DOM

RoomMessage = React.createFactory require './roomMessage'

module.exports = React.createClass

  displayName: 'room'

  mixins: [ReactIntl]

  contextTypes:
    user: React.PropTypes.object

  getInitialState: ->
    msg =
      timestamp: new Date()
      text: 'Welcome to Hearthy chat!'
      author: @context.user
    messages: [ msg ]

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
    messages.push
      timestamp: new Date()
      text: newMessage
      author: @context.user
    @setState messages

  render: ->
    div className: 'comp-room',
      div className: 'room-backlog', ref: 'log',
        @state.messages.map (m) ->
          RoomMessage message: m
      form className: 'room-footer', onSubmit: @handleMessage,
        input
          className: 'room-input'
          placeholder: @getIntlMessage('type-here')
          ref: 'msgbox'
        button className: 'room-send', @getIntlMessage('send')