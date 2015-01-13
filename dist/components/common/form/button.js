var React, button, div, _ref;

React = require('react');

_ref = React.DOM, div = _ref.div, button = _ref.button;

module.exports = React.createClass({
  render: function() {
    return div({
      id: this.props.id,
      className: 'field-set comp-button'
    }, button({
      type: 'submit'
    }, this.props.label));
  }
});
