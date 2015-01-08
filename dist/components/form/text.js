var React, div, input, label, _ref;

React = require('react');

input = React.createFactory(require('./input'));

_ref = React.DOM, div = _ref.div, label = _ref.label;

module.exports = React.createClass({
  render: function() {
    return div({
      id: this.props.id,
      className: 'field-set'
    }, div({
      className: 'label'
    }, label({
      className: 'label-form'
    }, this.props.label)), div({
      className: 'field'
    }, input({
      name: this.props.name,
      label: this.props.label,
      type: this.props.type,
      value: this.props.value,
      callback: this.props.callback
    })), div({
      className: 'message'
    }, label({
      className: 'message-form'
    })));
  }
});
