var React;

React = require('react');

module.exports = React.createClass({
  propTypes: {
    availableLocales: React.PropTypes.array.isRequired,
    value: React.PropTypes.string,
    onChange: React.PropTypes.func,
    valueLink: React.PropTypes.shape({
      value: React.PropTypes.string.isRequired,
      requestChange: React.PropTypes.func.isRequired
    })
  },
  getValueLink: function(props) {
    return props.valueLink || {
      value: props.value,
      requestChange: props.onChange
    };
  },
  handleChange: function(e) {
    this.getValueLink(this.props).requestChange(e.target.value);
  },
  render: function() {
    var value;
    value = this.getValueLink(this.props).value;
    console.log('VALUE', value);
    return React.createElement('select', {
      className: 'locale-select',
      value: value,
      onChange: this.handleChange
    }, this.props.availableLocales.map(function(locale) {
      return React.createElement('option', {
        key: locale,
        value: locale
      }, locale);
    }));
  }
});
