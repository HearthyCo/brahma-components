var ButtonForm, React, TextForm, a, form, _ref;

React = require('react');

TextForm = React.createFactory(require("../components/form/text"));

ButtonForm = React.createFactory(require("../components/form/button"));

_ref = React.DOM, form = _ref.form, a = _ref.a;

module.exports = React.createClass({
  render: function() {
    return form({
      action: this.props.action
    }, TextForm({
      label: "Email",
      name: "login",
      type: "email"
    }), TextForm({
      label: "Password",
      name: "password",
      type: "password"
    }), ButtonForm({
      label: "Login"
    }), a({
      href: "/register"
    }, "Register"));
  }
});
