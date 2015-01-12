var LocaleSelect, React, ReactIntl, div, section, _ref;

React = require('react');

ReactIntl = require('react-intl');

LocaleSelect = React.createFactory(require('../components/intl/localeSelect'));

_ref = React.DOM, section = _ref.section, div = _ref.div;

module.exports = React.createClass({
  mixins: [ReactIntl],
  getInitialState: function() {
    return {
      locale: this.props.intl.locale
    };
  },
  updateLocale: function(newLocale) {
    return this.setState({
      locale: newLocale
    });
  },
  render: function() {
    return section({
      id: 'page'
    }, div({
      id: 'locale-select'
    }, LocaleSelect({
      availableLocales: this.props.intl.availableLocales,
      value: this.state.locale,
      onChange: this.updateLocale
    })), div({
      id: 'content'
    }, React.createElement(this.props.element, {
      messages: this.props.intl.messages[this.state.locale]
    })));
  }
});
