React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

Utils = require '../../util/frontendUtils'

{ div, img, span, a } = React.DOM

module.exports = React.createClass

  displayName: 'mobileRoomMessage'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    message: React.PropTypes.object.isRequired

  contextTypes:
    user: React.PropTypes.object

  getIconForStatus: (status) ->
    if status is 'pending'
      span className: 'upload-status', '...'
    else if status is 'success'
      span className: 'upload-status icon icon-download'
    else if status is 'error'
      span className: 'upload-status icon icon-cross'

  render: ->
    if @props.message.type is 'message'
      body = @props.message.data.message
    else if @props.message.type is 'attachment'
      if @props.message.data.hasThumb
        # Show the preview
        href = @props.message.data.href
        body = div className: 'sent-img',
          span {},
            'ha enviado una imagen '
          a href: href, target: '_blank', 'VER'
          div {},
            a href: href, target: '_blank',
              img className: 'thumb', src: href + '_thumb'
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

    status = @props.message.status || 'success'
    own = @props.message.author is @context.user.id
    classes = 'comp-mobileroommessage message-status-' + status
    classes += if own then ' own' else ' remote'

    div className: classes,
      # No avatars or names here
      div className: 'message-body', body
