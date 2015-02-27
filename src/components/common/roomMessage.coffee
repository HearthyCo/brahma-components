React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

Utils = require '../../util/frontendUtils'

{ div, img, span, a } = React.DOM

module.exports = React.createClass

  displayName: 'roomMessage'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    message: React.PropTypes.object.isRequired

  render: ->
    avatar = @props.message.author.avatar || '/res/images/default-avatar.png'
    _this = @
    fullname = ['name', 'surname1', 'surname2']
      .map (f) -> _this.props.message.author[f]
      .filter (v) -> v
      .join ' '

    if @props.message.type is 'text'
      body = @props.message.text
    else if @props.message.type is 'attachment'
      body = span {},
        'ha enviado un archivo: '
        a href: @props.message.fileurl,
          @props.message.filename + ' (' +
            Utils.humanFilesize(@props.message.filesize) + ')'

    status = @props.message.status || 'success'

    div className: 'comp-roommessage message-status-' + status,
      img className: 'message-avatar', src: avatar
      div className: 'message-content',
        div className: 'message-header',
          span className: 'author', fullname + ' '
          span className: 'time',
            @formatTime @props.message.timestamp, 'time'
        div className: 'message-body', body
