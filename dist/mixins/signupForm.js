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
    var bdate, i, ret, _i, _len, _ref1;
    ret = {};
    bdate = {};
    _ref1 = this.getDOMNode().elements;
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      i = _ref1[_i];
      if (i.name) {
        if (i.type === 'radio') {
          if (i.checked) {
            ret[i.name] = i.value;
          }
        } else if (i.nodeName === 'SELECT') {
          bdate[i.name] = (i.value < 10 ? 0 + i.value : i.value);
        } else {
          ret[i.name] = i.value;
        }
      }
    }
    ret['birthdate'] = bdate.year + '-' + bdate.month + '-' + bdate.day;
    return ret;
  },
  render: function() {
    return form({
      action: "signup",
      onChange: this.handleChange,
      onSubmit: this.handleSubmit
    }, TextForm({
      id: 'username',
      label: "Username",
      name: "login",
      type: "text"
    }), TextForm({
      id: 'email',
      label: "Email",
      name: "email",
      type: "email"
    }), TextForm({
      id: 'password',
      label: "Password",
      name: "password",
      type: "password"
    }), TextForm({
      id: 'password-repeat',
      label: "Password repeat",
      type: "password"
    }), TextForm({
      id: 'name',
      label: "Name",
      name: "name",
      type: "text"
    }), GenderForm({
      id: 'gender',
      label: "Gender",
      name: "gender"
    }), DateForm({
      id: 'birthdate',
      label: "Birthdate",
      name: "birthdate"
    }), ButtonForm({
      id: 'signup',
      label: "Sign up"
    }), a({
      href: "/login"
    }, "Login"));
  }
});
