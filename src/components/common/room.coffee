React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

{ div, form, input, button, p } = React.DOM

RoomMessage = React.createFactory require './roomMessage'
ChatActions = require '../../actions/ChatActions'
ListStores = require '../../stores/ListStores'

module.exports = React.createClass

  displayName: 'room'

  mixins: [ReactIntl]

  propTypes:
    session: React.PropTypes.object.isRequired

  contextTypes:
    user: React.PropTypes.object

  getInitialState: ->
    messages: ListStores.Session.Messages.getObjects @props.session.id

  componentDidMount: ->
    ListStores.Session.Messages.addChangeListener @updateMessages

  componentWillUnmount: ->
    ListStores.Session.Messages.removeChangeListener @updateMessages

  componentWillUpdate: ->
    node = @refs.log.getDOMNode()
    @shouldScroll = node.scrollTop + node.offsetHeight is node.scrollHeight

  componentDidUpdate: ->
    if @shouldScroll
      node = @refs.log.getDOMNode()
      node.scrollTop = node.scrollHeight

  updateMessages: ->
    @setState messages: ListStores.Session.Messages.getObjects @props.session.id

  handleMessage: (e) ->
    e.preventDefault()
    msgbox = @refs.msgbox.getDOMNode()
    newMessage = msgbox.value.trim()
    msgbox.value = ''
    ChatActions.send @props.session.id, newMessage, @context.user

  render: ->
    div className: 'comp-room',
      div className: 'session-title',
        div className: 'session-client on',
          'A. Acuña García'
      div className: 'room-backlog', ref: 'log',
        @state.messages?.map (m) ->
          RoomMessage message: m
      form className: 'room-footer', onSubmit: @handleMessage,
        input
          className: 'room-input'
          placeholder: @getIntlMessage('type-here')
          ref: 'msgbox'
        button className: 'room-send', @getIntlMessage('send')
      div className: 'end-session',
        button {},
          'Finalizar consulta'