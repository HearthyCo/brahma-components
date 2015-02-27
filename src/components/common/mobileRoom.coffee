React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'
Utils = require '../../util/frontendUtils'

{ div, form, input, button, p } = React.DOM

RoomMessage = React.createFactory require './mobileRoomMessage'
ChatActions = require '../../actions/ChatActions'
EntityStores = require '../../stores/EntityStores'
ListStores = require '../../stores/ListStores'

module.exports = React.createClass

  displayName: 'mobileRoom'

  mixins: [ReactIntl]

  propTypes:
    session: React.PropTypes.object.isRequired

  getInitialState: ->
    messages: ListStores.Session.Messages.getObjects @props.session.id

  componentDidMount: ->
    EntityStores.Message.addChangeListener @updateMessages
    ListStores.Session.Messages.addChangeListener @updateMessages

  componentWillUnmount: ->
    EntityStores.Message.removeChangeListener @updateMessages
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

  handleUpload: (e) ->
    _this = @
    e.preventDefault()
    Utils.pickFile (e) ->
      for file in e.target.files
        ChatActions.sendFile _this.props.session.id, file, _this.context.user

  render: ->
    div className: 'comp-mobileRoom',
      div className: 'room-backlog', ref: 'log',
        @state.messages?.map (m) ->
          RoomMessage message: m
      form className: 'room-footer', onSubmit: @handleMessage,
        input
          className: 'room-input'
          placeholder: @getIntlMessage('type-here')
          ref: 'msgbox'
        button className: 'room-send', @getIntlMessage('send')
        button className: 'upload', onClick: @handleUpload, 'Upload'