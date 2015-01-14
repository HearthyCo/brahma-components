var IntlStore, React, ReactIntl, bottomBar, div, section, topBar, _, _ref;

React = require('react');

ReactIntl = require('react-intl');

_ = require('underscore');

IntlStore = require('../stores/IntlStore');

topBar = React.createFactory(require('../components/common/topBar'));

bottomBar = React.createFactory(require('../components/common/bottomBar'));

_ref = React.DOM, section = _ref.section, div = _ref.div;

module.exports = React.createClass({
  mixins: [ReactIntl],
  childContextTypes: {
    availableLocales: React.PropTypes.array.isRequired,
    locale: React.PropTypes.string.isRequired,
    messages: React.PropTypes.object.isRequired
  },
  getInitialState: function() {
    return {
      locale: IntlStore.locale,
      messages: IntlStore.messages
    };
  },
  getChildContext: function() {
    return {
      availableLocales: IntlStore.availableLocales,
      locale: this.state.locale,
      messages: this.state.messages[this.state.locale]
    };
  },
  componentDidMount: function() {
    return IntlStore.addChangeListener(this.updateLocale);
  },
  componentWillUnmount: function() {
    return TodoStore.removeChangeListener(this.updateLocale);
  },
  updateLocale: function() {
    return this.setState({
      locale: IntlStore.locale,
      messages: IntlStore.messages
    });
  },
  render: function() {
    var bottomBarProps;
    bottomBarProps = {
      availableLocales: IntlStore.availableLocales,
      locale: this.state.locale
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
