var React, input;

React = require('react');

input = React.DOM.input;

module.exports = React.createClass({
  render: function() {
    return input({
      className: 'radio-form',
      name: this.props.name,
      type: 'radio',
      value: this.props.value
    }, this.props.label);
  }
});
