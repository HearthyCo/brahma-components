var React, div, input, label, _, _ref;

React = require('react');

_ = require('underscore');

_ref = React.DOM, div = _ref.div, label = _ref.label, input = _ref.input;

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
    }, input(_.omit(this.props, 'id'))), div({
      className: 'message'
    }, label({
      className: 'message-form'
    })));
  }
});
