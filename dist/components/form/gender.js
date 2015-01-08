var React, div, input, label, _ref;

React = require('react');

input = React.createFactory(require('./input'));

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
      className: 'radio-form',
      name: this.props.name,
      value: 'hombre',
      type: 'radio'
    }), label({
      className: 'label-form'
    }, 'Hombre'), input({
      className: 'radio-form',
      name: this.props.name,
      value: 'mujer',
      type: 'radio'
    }), label({
      className: 'label-form'
    }, 'Mujer')));
  }
});
