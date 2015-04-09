React = require 'react/addons'
ReactIntl = require '../../mixins/ReactIntl'
_ = require 'underscore'
Utils = require '../../util/frontendUtils'

{ div, form, input, button, p, span } = React.DOM

RoomMessage = React.createFactory require './roomMessage'
ChatActions = require '../../actions/ChatActions'
SessionActions = require '../../actions/SessionActions'
EntityStores = require '../../stores/EntityStores'
ListStores = require '../../stores/ListStores'

StateStores = require '../../stores/StateStores'
InputStore = StateStores.chatTabs.inputs
OpenSections = StateStores.chatTabs.openSections


module.exports = React.createClass

  displayName: 'room'

  mixins: [ReactIntl]

  propTypes:
    session: React.PropTypes.object.isRequired
    #user: React.PropTypes.object

  contextTypes:
    user: React.PropTypes.object

  getInitialState: ->
    messages: ListStores.Session.Messages.getObjects @props.session?.id
    text: InputStore.get(@props.session?.id)

  componentDidMount: ->
    EntityStores.Message.addChangeListener @updateMessages
    ListStores.Session.Messages.addChangeListener @updateMessages
    InputStore.addChangeListener @updateText

  componentWillUnmount: ->
    EntityStores.Message.removeChangeListener @updateMessages
    ListStores.Session.Messages.removeChangeListener @updateMessages
    InputStore.removeChangeListener @updateText

  componentWillUpdate: ->
    node = @refs.log.getDOMNode()
    @shouldScroll = node.scrollTop + node.offsetHeight is node.scrollHeight

  componentWillReceiveProps: (next) ->
    if @props.session?.id isnt next.session?.id
      @updateMessages next
      @updateText next

  componentDidUpdate: ->
    if @shouldScroll
      node = @refs.log.getDOMNode()
      node.scrollTop = node.scrollHeight

  updateMessages: (props) ->
    props = props or @props
    @setState
      messages: ListStores.Session.Messages.getObjects props.session?.id

  updateText: (props) ->
    props = props or @props
    @setState
      text: InputStore.get(props.session?.id)

  handleMessage: (e) ->
    e.preventDefault()
    msgbox = @refs.msgbox.getDOMNode()
    newMessage = msgbox.value.trim()
    msgbox.value = ''
    InputStore.set @props.session.id, null
    ChatActions.send @props.session.id, newMessage, @context.user
    return # Prevent possible "return false" from previous line.

  handleUpload: (e) ->
    _this = @
    e.preventDefault()
    Utils.pickFile (e) ->
      for file in e.target.files
        ChatActions.sendFile _this.props.session.id, file, _this.context.user

  handleFinish: ->
    if @props.session.state isnt 'CLOSED'
      SessionActions.close @props.session.id
    OpenSections.set @props.session.id, 'report'


  render: ->
    classes = 'room-footer'
    if @state.text?.length
      classes += ' has-text'

    div className: 'comp-room',
      div className: 'room-wrapper',
        div className: 'room-backlog', ref: 'log',
          @state.messages?.map (m) ->
            RoomMessage key: m.id, message: m
      form className: classes, onSubmit: @handleMessage,
        input
          className: 'room-input'
          placeholder: @getIntlMessage 'type-here'
          valueLink: InputStore.linkState @props.session?.id
          ref: 'msgbox'
        button className: 'room-send', @getIntlMessage 'send'
        button className: 'upload', onClick: @handleUpload,
          span className: 'icon icon-clip'
      div className: 'end-session',
        button onClick: @handleFinish,
          @getIntlMessage 'finish'
