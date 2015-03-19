React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

Utils = require '../../util/frontendUtils'

EntityStores = require '../../stores/EntityStores'

{ div, img, span, a } = React.DOM

module.exports = React.createClass

  displayName: 'roomMessage'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    message: React.PropTypes.object.isRequired

  getIconForStatus: (status) ->
    if status is 'pending'
      span className: 'upload-status', '...'
    else if status is 'success'
      span className: 'upload-status icon icon-download'
    else if status is 'error'
      span className: 'upload-status icon icon-cross'

  componentDidMount: ->
    @makePreview()

  componentWillReceiveProps: ->
    @makePreview

  makePreview: ->
    # Try to generate a preview
    _this = @
    if @props.message.data.type?.startsWith 'image/'
      canvas = document.createElement 'canvas'
      if canvas.getContext and canvas.getContext '2d'
        image = new Image()
        maxSize = 125 # 300 # 125x80 ?
        image.onload = ->
          if image.width > image.height
            w = maxSize
            h = maxSize / image.width * image.height
          else
            w = maxSize / image.height * image.width
            h = maxSize
          ctx = canvas.getContext '2d'
          ctx.canvas.width = w
          ctx.canvas.height = h
          ctx.drawImage image, 0, 0, w, h
          _this.setState preview: element: canvas
        image.src = @props.message.data.href

  componentDidUpdate: ->
    if @refs.preview and @state?.preview?.element
      @refs.preview.getDOMNode().appendChild @state.preview.element

  render: ->
    author = EntityStores.User.get(@props.message.author) || {}
    avatar = author.avatar || '/res/images/default-avatar.png'
    fullname = ['name', 'surname1', 'surname2']
      .map (f) -> author[f]
      .filter (v) -> v
      .join ' '
    if @props.message.type is 'message'
      body = @props.message.data.message
    else if @props.message.type is 'attachment'
      if @state?.preview?.element
        # Show our preview
        href = @props.message.data.href
        body = div className: 'sent-img',
          span {},
            'ha enviado una imagen '
          a href: href, target: '_blank', 'VER'
          div {},
            a href: href, target: '_blank', ref: 'preview'
      else
        # Show the text version
        body = span {},
          'ha enviado un archivo: '
          a href: @props.message.data.href, target: '_blank',
            @props.message.data.message + ' (' +
              Utils.humanFilesize(@props.message.data.size) + ') '
          @getIconForStatus @props.message.status
    else
      return false

    status = @props.message.status || 'waiting'

    div className: 'comp-roommessage message-status-' + status,
      img className: 'message-avatar', src: avatar
      div className: 'message-content',
        div className: 'message-header',
          span className: 'author', fullname + ' '
          span className: 'time',
            @formatTime @props.message.timestamp, 'time'
        div className: 'message-body', body
