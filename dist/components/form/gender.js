var React, ReactIntlMixin, div, label, radio, _ref;

React = require('react');

ReactIntlMixin = require('react-intl');

radio = React.createFactory(require('./radio'));

_ref = React.DOM, div = _ref.div, label = _ref.label;

module.exports = React.createClass({
  mixins: [ReactIntlMixin],
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
      label: this.getIntlMessage('male'),
      name: this.props.name,
      value: 'MALE',
      checked: this.props.value === 'MALE',
      callback: this.props.callback
    }), radio({
      label: this.getIntlMessage('female'),
      name: this.props.name,
      value: 'FEMALE',
      checked: this.props.value === 'FEMALE',
      callback: this.props.callback
    }), radio({
      label: this.getIntlMessage('other'),
      name: this.props.name,
      value: 'OTHER',
      checked: this.props.value === 'OTHER',
      callback: this.props.callback
    })), div({
      className: 'message'
    }, label({
      className: 'message-form'
    })));
  }
});
