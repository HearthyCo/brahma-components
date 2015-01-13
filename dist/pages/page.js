var IntlActions, LocaleSelect, React, ReactIntl, div, section, _, _ref;

React = require('react');

ReactIntl = require('react-intl');

_ = require('underscore');

LocaleSelect = React.createFactory(require('../components/intl/localeSelect'));

IntlActions = require('../actions/IntlActions');

_ref = React.DOM, section = _ref.section, div = _ref.div;

module.exports = React.createClass({
  mixins: [ReactIntl],
  getInitialState: function() {
    return {
      locale: this.props.intl.locale,
      messages: this.props.intl.messages
    };
  },
  translate: function(locale, messages) {
    return this.setState({
      locale: locale,
      messages: _.extend(this.state.messages, messages)
    });
  },
  updateLocale: function(newLocale) {
    if (!this.state.messages[newLocale]) {
      return IntlActions.translate(newLocale, this.translate);
    } else {
      return this.translate(newLocale);
    }
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
      messages: this.state.messages[this.state.locale]
    })));
  }
});
