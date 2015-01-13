var React, SignupForm, a, div, span, _, _ref;

React = require('react/addons');

_ = require('underscore');

SignupForm = React.createFactory(require('../components/user/signupForm'));

_ref = React.DOM, div = _ref.div, span = _ref.span, a = _ref.a;

module.exports = React.createClass({
  render: function() {
    return div({}, SignupForm(), a({
      href: "/alex",
      className: "linkAlex"
    }, "Álex ", span({}, "Ubago")));
  }
});
