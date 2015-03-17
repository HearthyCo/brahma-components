React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

{ div, ul, li, span, a } = React.DOM
UserBrief = React.createFactory require '../user/userBrief'

module.exports = React.createClass

  displayName: 'adminMenu'

  mixins: [ReactIntl]

  contextTypes:
    user: React.PropTypes.object

  render: ->
    div id: 'menu',
      div className: 'top-area',
        a href: '/',
          div className: 'logo'
      div className: 'middle-area',
        a href: '/crud/professional', 'Professionals'