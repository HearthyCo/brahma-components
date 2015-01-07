var ButtonForm, DateForm, GenderForm, React, TextForm, UserActions, a, form, _ref;

React = require('react');

TextForm = React.createFactory(require("../components/form/text"));

DateForm = React.createFactory(require("../components/form/date"));

GenderForm = React.createFactory(require("../components/form/gender"));

ButtonForm = React.createFactory(require("../components/form/button"));

_ref = React.DOM, form = _ref.form, a = _ref.a;

UserActions = require("../actions/UserActions");

module.exports = React.createClass({
  handleSubmit: function(e) {
    e.preventDefault();
    return UserActions.register(this.getFormValue());
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
    console.log(JSON.stringify(ret));
    return ret;
  },
  render: function() {
    return form({
      action: "signup",
      onChange: this.handleChange,
      onSubmit: this.handleSubmit
    }, TextForm({
      label: "Username",
      name: "login",
      type: "text"
    }), TextForm({
      label: "Email",
      name: "email",
      type: "email"
    }), TextForm({
      label: "Password",
      name: "password",
      type: "password"
    }), TextForm({
      label: "Password repeat",
      type: "password"
    }), TextForm({
      label: "Name",
      name: "name",
      type: "text"
    }), GenderForm({
      label: "Gender",
      name: "gender"
    }), DateForm({
      label: "Birthdate",
      name: "birthdate"
    }), ButtonForm({
      label: "Sign up"
    }), a({
      href: "/login"
    }, "Login"));
  }
});
