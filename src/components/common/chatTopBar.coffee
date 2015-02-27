React = require 'react/addons'
_ = require 'underscore'

{ header, div, a, span, img } = React.DOM

module.exports = React.createClass

  displayName: 'chatTopBar'

  propTypes:
    user: React.PropTypes.object

  render: ->
    if @props.user
      avatar = @props.user.avatar || '/res/images/default-avatar.png'
      _this = @
      fullname = ['name', 'surname1', 'surname2']
        .map (f) -> _this.props.user[f]
        .filter (v) -> v
        .join ' '

      userBar = div className: 'bar-profile',
        img className: 'avatar', src: avatar
        div className: 'details',
          span class: 'name', fullname
          a href: '/', 'Ver perfil y curriculum'

    header className: 'comp-chatTopBar',
      div className: 'menuBar',
        a href: '/',
          span className: 'icon icon-arrow-left'
      userBar