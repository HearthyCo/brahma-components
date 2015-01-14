var Backbone, IntlActions, React;

React = require('react');

Backbone = require('exoskeleton');

IntlActions = require('../../../actions/IntlActions');

module.exports = React.createClass({
  contextTypes: {
    availableLocales: React.PropTypes.array.isRequired,
    locale: React.PropTypes.string.isRequired,
    messages: React.PropTypes.object.isRequired
  },
  handleChange: function(ev) {
    return IntlActions.requestChange(ev.target.value);
  },
  render: function() {
    return React.createElement('select', {
      className: 'comp-localeSelect',
      value: this.context.locale,
      onChange: this.handleChange
    }, this.context.availableLocales.map(function(locale) {
      return React.createElement('option', {
        key: locale,
        value: locale
      }, locale);
    }));
  }
});
