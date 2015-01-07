var React, div, input, label, _ref;

React = require('react');

_ref = React.DOM, div = _ref.div, label = _ref.label, input = _ref.input;

module.exports = React.createClass({
  render: function() {
    return input({
      className: this.props.className,
      name: this.props.name,
      placeholder: this.props.label,
      type: this.props.type
    });
  }
});
