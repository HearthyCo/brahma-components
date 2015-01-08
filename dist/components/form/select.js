var React, select;

React = require('react');

select = React.DOM.select;

module.exports = React.createClass({
  render: function() {
    return select({
      className: 'select-form',
      name: this.props.name
    }, this.props.options);
  }
});
