React = require 'react/addons'
_ = require 'underscore'

{ header, div, a, span } = React.DOM
UserBrief = React.createFactory require '../user/userBrief'

module.exports = React.createClass

  displayName: 'professionalMenu'

  contextTypes:
    user: React.PropTypes.object

  render: ->
    div id: 'menu',
      if @context.user
        UserBrief user: @context.user