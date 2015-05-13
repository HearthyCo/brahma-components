React = require 'react/addons'
_ = require 'underscore'
Utils = require '../../util/frontendUtils'


{ header, div, a, span, img } = React.DOM

PageActions = require '../../actions/PageActions'
PageStore = require '../../stores/PageStore'
BreadcrumbStore = require '../../stores/BreadcrumbStore'

module.exports = React.createClass

  displayName: 'chatTopBar'

  propTypes:
    user: React.PropTypes.object
    backAction: React.PropTypes.func
    noLink: React.PropTypes.bool

  handleBackClick: (e) ->
    if @props.backAction
      e.stopPropagation()
      @props.backAction()
    else
      # back = PageStore.getBack()
      # PageActions.change back.current, back.opts
      BreadcrumbStore.goUp()

  render: ->
    if @props.user
      avatar = @props.user.avatar or '/res/images/default-avatar.png'
      fullname = Utils.fullName @props.user

      url = "/session/#{@props.sessionId}/user/#{@props.user.id}"
      userBar = div className: 'bar-profile',
        img className: 'avatar', src: avatar
        div className: 'details',
          span className: 'name', fullname
          if not @props.noLink
            a href: url, 'Ver perfil y curriculum'

    header className: 'comp-chatTopBar',
      div className: 'chatTopBar-wrapper',
        div className: 'menuBar',
          span className: 'icon icon-arrow-left', onClick: @handleBackClick,
        userBar