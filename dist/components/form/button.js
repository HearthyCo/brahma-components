var React, button, div, _ref;

React = require('react');

_ref = React.DOM, div = _ref.div, button = _ref.button;

module.exports = React.createClass({
  render: function() {
    return div({
      className: "field-set"
    }, button({
      type: "submit"
    }, this.props.label));
  }
});
