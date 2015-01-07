var ButtonForm, InputForm, React, a, form, _ref;

React = require('react');

InputForm = React.createFactory(require("../components/form/input"));

ButtonForm = React.createFactory(require("../components/form/button"));

_ref = React.DOM, form = _ref.form, a = _ref.a;

module.exports = React.createClass({
  render: function() {
    return form({
      action: this.props.action
    }, InputForm({
      label: "Email",
      name: "login",
      type: "email"
    }), InputForm({
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
