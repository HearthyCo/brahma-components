var LocaleSelect, React, div, footer, _, _ref;

React = require('react/addons');

_ = require('underscore');

LocaleSelect = React.createFactory(require('./intl/localeSelect'));

_ref = React.DOM, footer = _ref.footer, div = _ref.div;

module.exports = React.createClass({
  render: function() {
    return footer({
      className: 'comp-bottomBar'
    }, div({
      className: 'left-box'
    }, "Left"), div({
      className: 'center-box'
    }, "Center"), div({
      className: 'right-box'
    }, div({
      id: 'locale-select'
    }, LocaleSelect({}))));
  }
});
