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

  render: ->
    if @props.message.type is 'text'
      body = @props.message.text
    else if @props.message.type is 'attachment'
      body = span {},
        'ha enviado un archivo: '
        a href: @props.message.fileurl,
          @props.message.filename + ' (' +
            Utils.humanFilesize(@props.message.filesize) + ')'

    status = @props.message.status || 'success'
    own = @props.message.author is @context.user
    classes = 'comp-mobileroommessage message-status-' + status
    classes += if own then 'own' else 'remote'

    div className: classes,
      # No avatars or names here
      div className: 'message-body', body
