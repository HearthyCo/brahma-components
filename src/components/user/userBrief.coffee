React = require 'react'
Utils = require '../../util/frontendUtils'

{ div, img } = React.DOM

module.exports = React.createClass

  displayName: 'userBrief'

  propTypes:
    id: React.PropTypes.string
    user: React.PropTypes.object.isRequired

  render: ->
    avatar = @props.user.avatar or '/res/images/default-avatar.png'
    fullname = Utils.fullName @props.user

    div id: @props.id, className: 'comp-userbrief',
      img className: 'avatar', src: avatar
      div className: 'name', fullname
