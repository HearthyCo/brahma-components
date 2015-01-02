var React, div, input, label, _ref;

React = require('react');

_ref = React.DOM, div = _ref.div, label = _ref.label, input = _ref.input;

module.exports = React.createClass({
  render: function() {
    return div({
      className: 'field-set'
    }, [
      div({
        className: 'field'
      }, [
        label({
          className: 'label-form'
        }, this.props.fieldName)
      ]), div({
        className: 'field'
      }, [
        input({
          className: 'input-form',
          placeholder: this.props.fieldName,
          type: this.props.type
        })
      ])
    ]);
  }
});
