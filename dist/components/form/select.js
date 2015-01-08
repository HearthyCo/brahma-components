var React, select;

React = require('react');

select = React.DOM.select;

module.exports = React.createClass({
  handleChange: function(e) {
    if (this.props.callback) {
      return this.props.callback(this.props.name, e.target.value);
    }
  },
  render: function() {
    return select({
      className: 'select-form',
      name: this.props.name,
      onChange: this.handleChange
    }, this.props.options);
  }
});
