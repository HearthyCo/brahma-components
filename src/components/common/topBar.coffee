React = require 'react/addons'
_ = require 'underscore'

{ header, div, a } = React.DOM

module.exports = React.createClass
  render: ->
    header className: 'comp-topBar',
      div className: 'topBar-wrapper',
        div className: 'left-box',
          div className: 'menuBar',
            a className: 'menu-icon', href: '#',
              "| | |"
        div className: 'center-box',
          div className: 'logoBar',
            "Brahma"
        div className: 'right-box',
          div className: 'iconBar',