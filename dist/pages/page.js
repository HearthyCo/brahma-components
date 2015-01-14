var IntlActions, React, ReactIntl, bottomBar, div, section, topBar, _, _ref;

React = require('react');

ReactIntl = require('react-intl');

_ = require('underscore');

IntlActions = require('../actions/IntlActions');

topBar = React.createFactory(require('../components/common/topBar'));

bottomBar = React.createFactory(require('../components/common/bottomBar'));

_ref = React.DOM, section = _ref.section, div = _ref.div;

module.exports = React.createClass({
  mixins: [ReactIntl],
  childContextTypes: {
    locale: React.PropTypes.string.isRequired,
    messages: React.PropTypes.object.isRequired
  },
  getInitialState: function() {
    return {
      locale: this.props.intl.locale,
      messages: this.props.intl.messages
    };
  },
  getChildContext: function() {
    return {
      locale: this.state.locale,
      messages: this.state.messages[this.state.locale]
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
    var bottomBarProps, localeLink;
    localeLink = {
      value: this.state.locale,
      requestChange: this.updateLocale
    };
    bottomBarProps = {
      availableLocales: this.props.intl.availableLocales,
      locale: localeLink
    };
    return div({
      className: 'comp-page'
    }, topBar({}), section({
      className: 'main-section'
    }, div({
      id: 'content'
    }, React.createElement(this.props.element))), bottomBar(bottomBarProps));
  }
});
