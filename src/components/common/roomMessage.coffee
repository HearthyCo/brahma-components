React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

{ div, img, span } = React.DOM

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


    div className: 'comp-roommessage',
      img className: 'message-avatar', src: avatar
      div className: 'message-content',
        div className: 'message-header',
          span className: 'author', fullname + ' '
          span className: 'time',
            @formatTime @props.message.timestamp, 'time'
        div className: 'message-body',
          @props.message.text