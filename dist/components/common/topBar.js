var React, div, header, _, _ref;

React = require('react/addons');

_ = require('underscore');

_ref = React.DOM, header = _ref.header, div = _ref.div;

module.exports = React.createClass({
  render: function() {
    return header({
      className: 'comp-topBar'
    }, div({
      className: 'left-box'
    }, "Left"), div({
      className: 'center-box'
    }, "Center"), div({
      className: 'right-box'
    }, "Right"));
  }
});
