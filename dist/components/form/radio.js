var React, input;

React = require('react');

input = React.DOM.input;

module.exports = React.createClass({
  handleChange: function(e) {
    if (this.props.callback && e.target.checked) {
      return this.props.callback(this.props.name, e.target.value);
    }
  },
  render: function() {
    return input({
      className: 'radio-form',
      name: this.props.name,
      type: 'radio',
      value: this.props.value,
      checked: this.props.checked,
      onChange: this.handleChange
    }, this.props.label);
  }
});
