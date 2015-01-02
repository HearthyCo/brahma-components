React = require 'react'

module.exports = React.createClass(
  propTypes:
    active: React.PropTypes.bool
    onSelect: React.PropTypes.func

  render: ->
    # just pass the onSelect handler in directly
    # let the parent handle it
    @transferPropsTo (a  { className: @props.active ? 'active' : '', onClick: this.props.onSelect }, [
      this.props.label
    ])
)