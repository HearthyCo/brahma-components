React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'
Utils = require '../../util/frontendUtils'

{ div, form, input, button, p, span } = React.DOM

RoomMessage = React.createFactory require './roomMessage'
ChatActions = require '../../actions/ChatActions'
EntityStores = require '../../stores/EntityStores'
ListStores = require '../../stores/ListStores'

module.exports = React.createClass

  displayName: 'room'

  mixins: [ReactIntl]

  propTypes:
    session: React.PropTypes.object.isRequired
    user: React.PropTypes.object

  contextTypes:
    user: React.PropTypes.object

  getInitialState: ->
    messages: ListStores.Session.Messages.getObjects @props.session?.id
    hasText: false

  componentDidMount: ->
    EntityStores.Message.addChangeListener @updateMessages
    ListStores.Session.Messages.addChangeListener @updateMessages

  componentWillUnmount: ->
    EntityStores.Message.removeChangeListener @updateMessages
    ListStores.Session.Messages.removeChangeListener @updateMessages

  componentWillUpdate: ->
    node = @refs.log.getDOMNode()
    @shouldScroll = node.scrollTop + node.offsetHeight is node.scrollHeight

  componentWillReceiveProps: (next) ->
    if @props.session?.id isnt next.session?.id
      @updateMessages next

  componentDidUpdate: ->
    if @shouldScroll
      node = @refs.log.getDOMNode()
      node.scrollTop = node.scrollHeight

  updateMessages: (props) ->
    props = props || @props
    @setState
      messages: ListStores.Session.Messages.getObjects props.session?.id

  handleMessage: (e) ->
    e.preventDefault()
    msgbox = @refs.msgbox.getDOMNode()
    newMessage = msgbox.value.trim()
    msgbox.value = ''
    @setState hasText: false
    ChatActions.send @props.session.id, newMessage, @context.user
    return # Prevent possible "return false" from previous line.

  handleUpload: (e) ->
    _this = @
    e.preventDefault()
    Utils.pickFile (e) ->
      for file in e.target.files
        ChatActions.sendFile _this.props.session.id, file, _this.context.user

  handleChange: (e) ->
    @setState hasText: e.target.value isnt ""


  render: ->
    classes = 'room-footer'
    if @state.hasText
      classes += ' has-text'

    _this = @
    if @props.user
      fullname = ['name', 'surname1', 'surname2']
        .map (f) -> _this.props.user[f]
        .filter (v) -> v
        .join ' '
    else
      fullname = @getIntlMessage 'loading'

    div className: 'comp-room',
      div className: 'session-title',
        div className: 'session-client on',
          fullname
      div className: 'room-backlog', ref: 'log',
        @state.messages?.map (m) ->
          RoomMessage key: m.id, message: m
      form className: classes, onSubmit: @handleMessage,
        input
          className: 'room-input'
          placeholder: @getIntlMessage('type-here')
          onChange: @handleChange
          ref: 'msgbox'
        button className: 'room-send', @getIntlMessage('send')
        button className: 'upload', onClick: @handleUpload,
          span className: 'icon icon-clip'
      div className: 'end-session',
        button {},
          'Finalizar consulta'
