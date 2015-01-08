var React, input;

React = require('react');

input = React.DOM.input;

module.exports = React.createClass({
  render: function() {
    return input({
      className: 'input-form',
      name: this.props.name,
      placeholder: this.props.label,
      type: this.props.type,
      value: this.props.value
    });
  }
});
