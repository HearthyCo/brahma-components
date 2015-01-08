var React, input;

React = require('react');

input = React.DOM.input;

module.exports = React.createClass({
  handleChange: function(e) {
    if (this.props.callback) {
      return this.props.callback(this.props.name, e.target.value);
    }
  },
  render: function() {
    return input({
      className: 'input-form',
      name: this.props.name,
      placeholder: this.props.placeholder,
      type: this.props.type,
      value: this.props.value,
      onChange: this.handleChange
    });
  }
});
