var React, div, input, label, _ref;

React = require('react');

_ref = React.DOM, div = _ref.div, label = _ref.label, input = _ref.input;

module.exports = React.createClass({
  handleChange: function(value, e) {
    if (this.props.valueLink && e.target.checked) {
      return this.props.valueLink.requestChange(value);
    }
  },
  mkRadio: function(label, value) {
    var actualValue;
    actualValue = this.props.valueLink ? this.props.valueLink.value : void 0;
    return input({
      className: 'radio-form',
      type: 'radio',
      label: label,
      name: this.props.name,
      value: value,
      checked: actualValue === value,
      onChange: this.handleChange.bind(this, value)
    }, label);
  },
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
    }, this.mkRadio('Hombre', 'MALE'), this.mkRadio('Mujer', 'FEMALE'), this.mkRadio('Otro', 'OTHER')), div({
      className: 'message'
    }, label({
      className: 'message-form'
    })));
  }
});
