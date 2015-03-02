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

  render: ->
    if @props.message.type is 'text'
      body = @props.message.text
    else if @props.message.type is 'attachment'
      body = span {},
        'ha enviado un archivo: '
        a href: @props.message.fileurl, target: '_blank',
          @props.message.filename + ' (' +
            Utils.humanFilesize(@props.message.filesize) + ')'

    status = @props.message.status || 'success'

    div className: 'comp-roommessage message-status-' + status,
      # No avatars or names here
      div className: 'message-body', body
