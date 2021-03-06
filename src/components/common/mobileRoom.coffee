React = require 'react/addons'
ReactIntl = require '../../mixins/ReactIntl'
_ = require 'underscore'
Utils = require '../../util/frontendUtils'

{ div, form, input, button, p, span } = React.DOM

RoomMessage = React.createFactory require './mobileRoomMessage'
InputMultiline = React.createFactory require './form/inputMultiline'
ChatActions = require '../../actions/ChatActions'
EntityStores = require '../../stores/EntityStores'
ListStores = require '../../stores/ListStores'

module.exports = React.createClass

  displayName: 'mobileRoom'

  mixins: [ReactIntl]

  propTypes:
    session: React.PropTypes.object.isRequired

  contextTypes:
    user: React.PropTypes.object

  getInitialState: ->
    messages: ListStores.Session.Messages.getObjects @props.session.id
    hasText: false
    hasProfessional:
      ListStores.Session.Participants.getIds(@props.session.id)?.length > 1

  componentDidMount: ->
    EntityStores.Message.addChangeListener @updateMessages
    ListStores.Session.Messages.addChangeListener @updateMessages
    ListStores.Session.Participants.addChangeListener @updateParticipants
    node = @refs.log.getDOMNode()
    node.scrollTop = node.scrollHeight
    # Attach DOM resize event to scroll on resize
    window.addEventListener 'resize', @handleResize
    node.addEventListener 'scroll', @handleScroll

  componentWillUnmount: ->
    EntityStores.Message.removeChangeListener @updateMessages
    ListStores.Session.Messages.removeChangeListener @updateMessages
    ListStores.Session.Participants.removeChangeListener @updateParticipants
    window.removeEventListener 'resize', @handleResize
    node = @refs.log.getDOMNode()
    node.removeEventListener 'scroll', @handleScroll

  componentWillUpdate: ->
    node = @refs.log.getDOMNode()
    @shouldScroll = node.scrollTop + node.offsetHeight is node.scrollHeight

  componentDidUpdate: ->
    if @shouldScroll
      node = @refs.log.getDOMNode()
      node.scrollTop = node.scrollHeight

  handleScroll: ->
    node = @refs.log.getDOMNode()
    @shouldScroll = node.scrollTop + node.offsetHeight is node.scrollHeight

  handleResize: ->
    if @shouldScroll
      node = @refs.log.getDOMNode()
      node.scrollTop = node.scrollHeight

  updateMessages: ->
    @setState messages: ListStores.Session.Messages.getObjects @props.session.id

  updateParticipants: ->
    @setState hasProfessional:
      ListStores.Session.Participants.getIds(@props.session.id)?.length > 1

  sendMessage: (msg) ->
    if msg
      ChatActions.send @props.session.id, msg, @context.user
    return

  handleSubmit: (e) ->
    e.preventDefault()
    @sendMessage @refs.msgbox.getValue()
    # Clear input
    @refs.msgbox.setValue ""
    @setState hasText: false
    return

  handleUpload: (e) ->
    _this = @
    e.preventDefault()
    Utils.pickFile (e) ->
      for file in e.target.files
        ChatActions.sendFile _this.props.session.id, file, _this.context.user

  handleChange: ->
    @setState hasText: @refs.msgbox.getValue() isnt ""

  render: ->
    classes = 'room-footer'
    if @state.hasText
      classes += ' has-text'

    div className: 'comp-mobileRoom',
      div className: 'room-wrapper',
        div className: 'room-backlog', ref: 'log',
          if not @state.hasProfessional
            div className: 'notification-message',
              div className: 'message-body',
                @getIntlMessage 'no-doctors-message'

          @state.messages?.map (m) ->
            RoomMessage key: m.id, message: m

          if @props.session?.state is 'CLOSED'
            div className: 'notification-message',
              div className: 'message-body',
                @getIntlMessage 'session-closed-message'

      if @props.session?.state in ['CLOSED', 'FINISHED']
        div className: 'session-chat-closed',
          @getIntlMessage 'session-chat-closed'
      else
        form className: classes, onSubmit: @handleSubmit, ref: 'form',
          InputMultiline
            className: 'room-input'
            placeholder: @getIntlMessage('type-here')
            onChange: @handleChange
            onEnter: @handleSubmit
            ref: 'msgbox'
          button className: 'room-send', @getIntlMessage('send')
          button className: 'upload', onClick: @handleUpload,
            span className: 'icon icon-reel'
