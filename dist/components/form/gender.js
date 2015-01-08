var React, div, label, radio, _ref;

React = require('react');

radio = React.createFactory(require('./radio'));

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
    }, radio({
      label: 'Hombre',
      name: this.props.name,
      value: 'MALE'
    }), radio({
      label: 'Mujer',
      name: this.props.name,
      value: 'FEMALE'
    }), radio({
      label: 'Otro',
      name: this.props.name,
      value: 'OTHER'
    })), div({
      className: 'message'
    }, label({
      className: 'message-form'
    })));
  }
});
