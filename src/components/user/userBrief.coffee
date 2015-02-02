React = require 'react'

{ div, img } = React.DOM

module.exports = React.createClass

  displayName: 'userBrief'

  propTypes:
    id: React.PropTypes.string
    user: React.PropTypes.object.isRequired

  render: ->
    @props.user.avatar = @props.user.avatar || '/res/images/default-avatar.png'
    _this = @
    fullname = ['name', 'surname1', 'surname2']
      .map (f) -> _this.props.user[f]
      .filter (v) -> v
      .join ' '

    div id: @props.id, className: 'comp-userbrief',
      img className: 'avatar', src: @props.user.avatar
      div className: 'name', fullname
