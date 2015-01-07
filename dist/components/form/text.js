var React, div, input, label, _ref;

React = require('react');

input = require('./input');

_ref = React.DOM, div = _ref.div, label = _ref.label;

module.exports = React.createClass({
  render: function() {
    return div({
      className: 'field-set'
    }, div({
      className: 'field'
    }, label({
      className: 'label-form'
    }, this.props.label)), div({
      className: 'field'
    }, input({
      className: 'input-form',
      name: this.props.name,
      placeholder: this.props.label,
      type: this.props.type
    })));
  }
});
