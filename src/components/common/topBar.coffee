React = require 'react/addons'
_ = require 'underscore'

{ header, div, a, span } = React.DOM

module.exports = React.createClass

  displayName: 'topBar'

  render: ->
    header className: 'comp-topBar',
      div className: 'topBar-wrapper',
        div className: 'left-box',
          div className: 'menuBar',
            a href: '/',
              span className: 'icon icon-arrow-left'
        div className: 'center-box',
          a href: '/',
            div className: 'logoBar'
        div className: 'right-box',
          div className: 'iconBar'