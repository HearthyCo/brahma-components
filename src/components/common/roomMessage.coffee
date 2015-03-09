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

  render: ->
    author = EntityStores.User.get @props.message.author
    avatar = author.avatar || '/res/images/default-avatar.png'
    fullname = ['name', 'surname1', 'surname2']
      .map (f) -> author[f]
      .filter (v) -> v
      .join ' '

    if @props.message.type is 'message'
      body = @props.message.data.message
    else if @props.message.type is 'attachment'
      body = span {},
        'ha enviado un archivo: '
        a href: @props.message.data.href, target: '_blank',
          @props.message.data.message + ' (' +
            Utils.humanFilesize(@props.message.data.size) + ')'

    status = @props.message.status || 'waiting'

    div className: 'comp-roommessage message-status-' + status,
      img className: 'message-avatar', src: avatar
      div className: 'message-content',
        div className: 'message-header',
          span className: 'author', fullname + ' '
          span className: 'time',
            @formatTime @props.message.timestamp, 'time'
        div className: 'message-body', body
