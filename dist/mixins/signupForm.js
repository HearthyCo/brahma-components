var ButtonForm, InputForm, React, UserStore, a, form, _ref;

React = require('react');

InputForm = React.createFactory(require("../components/form/input"));

ButtonForm = React.createFactory(require("../components/form/button"));

_ref = React.DOM, form = _ref.form, a = _ref.a;

UserStore = require("../stores/UserStore");

module.exports = React.createClass({
  handleSubmit: function(e) {
    var user;
    e.preventDefault();
    user = new UserStore;
    return user.save(this.getFormValue(), {
      success: function(e) {
        return console.log('Register success!', e);
      },
      error: function(e) {
        return console.log('Error registering!', e);
      }
    });
  },
  handleChange: function(e) {},
  getFormValue: function() {
    var i, ret, _i, _len, _ref1;
    ret = {};
    _ref1 = this.getDOMNode().elements;
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      i = _ref1[_i];
      if (i.name) {
        ret[i.name] = i.value;
      }
    }
    return ret;
  },
  render: function() {
    return form({
      action: "signup",
      onChange: this.handleChange,
      onSubmit: this.handleSubmit
    }, InputForm({
      label: "Username",
      name: "login",
      type: "text"
    }), InputForm({
      label: "Email",
      name: "email",
      type: "email"
    }), InputForm({
      label: "Password",
      name: "password",
      type: "password"
    }), InputForm({
      label: "Password repeat",
      type: "password"
    }), InputForm({
      label: "Name",
      name: "name",
      type: "text"
    }), InputForm({
      label: "Gender",
      name: "gender",
      type: "text"
    }), InputForm({
      label: "Birthdate",
      name: "birthdate",
      type: "text"
    }), ButtonForm({
      label: "Sign up"
    }), a({
      href: "/login"
    }, "Login"));
  }
});
