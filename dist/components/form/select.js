var React, div, label, select, _ref;

React = require("react");

_ref = React.DOM, div = _ref.div, label = _ref.label, select = _ref.select;

module.exports = React.createClass({
  render: function() {
    return div({
      className: "field-set"
    }, div({
      className: "field"
    }, label({
      className: "label-form"
    }, this.props.label)), div({
      className: "field"
    }, select({
      className: "select-form",
      name: this.props.name
    }, this.props.options)));
  }
});
