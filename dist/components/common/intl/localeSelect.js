var Backbone, React;

React = require('react');

Backbone = require('exoskeleton');

module.exports = React.createClass({
  propTypes: {
    availableLocales: React.PropTypes.array.isRequired,
    value: React.PropTypes.string,
    onChange: React.PropTypes.func
  },
  handleChange: function(ev) {
    return this.props.onChange(ev.target.value);
  },
  render: function() {
    return React.createElement('select', {
      className: 'locale-select',
      value: this.props.value,
      onChange: this.handleChange
    }, this.props.availableLocales.map(function(locale) {
      return React.createElement('option', {
        key: locale,
        value: locale
      }, locale);
    }));
  }
});
