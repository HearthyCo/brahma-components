React = require 'react/addons'
_ = require 'underscore'

{ header, div, a, span, img } = React.DOM

module.exports = React.createClass

  displayName: 'chatTopBar'

  propTypes:
    user: React.PropTypes.object
    backAction: React.PropTypes.func

  handleBackClick: (e) ->
    if @props.backAction
      e.stopPropagation()
      @props.backAction()

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
          span className: 'name', fullname
          a href: '/', 'Ver perfil y curriculum'

    header className: 'comp-chatTopBar',
      div className: 'chatTopBar-wrapper',
        div className: 'menuBar',
          span className: 'icon icon-arrow-left', onClick: @handleBackClick,
        userBar