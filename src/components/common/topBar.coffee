React = require 'react/addons'
_ = require 'underscore'

{ header, div } = React.DOM

module.exports = React.createClass
  render: ->
    header className: 'comp-topBar',
      div className: 'left-box',
        "Left"
      div className: 'center-box',
        "Center"
      div className: 'right-box',
        "Right"