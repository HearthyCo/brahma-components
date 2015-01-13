var DateForm, GenderForm, ObjectTools, React, ReactIntl, TextForm, UserActions, a, button, form, _, _ref;

React = require('react/addons');

ReactIntl = require('react-intl');

_ = require('underscore');

TextForm = React.createFactory(require('../common/form/text'));

DateForm = React.createFactory(require('../common/form/date'));

GenderForm = React.createFactory(require('../common/form/gender'));

_ref = React.DOM, form = _ref.form, a = _ref.a, button = _ref.button;

UserActions = require('../../actions/UserActions');

ObjectTools = require('../../util/objectTools');

module.exports = React.createClass({
  mixins: [React.addons.LinkedStateMixin, ReactIntl],
  handleSubmit: function(e) {
    var obj;
    e.preventDefault();
    obj = _.extend({}, this.state);
    delete obj["password-repeat"];
    return UserActions.register(obj);
  },
  getInitialState: function() {
    return {};
  },
  buildComp: function(type, opt) {
    var obj;
    obj = {
      id: opt.name,
      label: opt.label,
      name: opt.name,
      type: type,
      valueLink: this.linkState(opt.name)
    };
    switch (type) {
      case 'text':
        return TextForm(obj);
      case 'email':
        return TextForm(obj);
      case 'password':
        return TextForm(obj);
      case 'gender':
        return GenderForm(obj);
      case 'date':
        return DateForm(obj);
      case 'button':
        return button({
          id: opt.name
        }, opt.label);
    }
  },
  render: function() {
    var birthdate, email, gender, login, name, password, repeat, signup, username;
    username = this.getIntlMessage('username');
    email = this.getIntlMessage('email');
    password = this.getIntlMessage('password');
    repeat = this.getIntlMessage('repeat');
    name = this.getIntlMessage('name');
    gender = this.getIntlMessage('gender');
    birthdate = this.getIntlMessage('birthdate');
    signup = this.getIntlMessage('signup');
    login = this.getIntlMessage('login');
    return form({
      action: 'signup',
      onSubmit: this.handleSubmit,
      className: 'comp-signupForm'
    }, this.buildComp('text', {
      label: username,
      name: 'login'
    }), this.buildComp('email', {
      label: email,
      name: 'email'
    }), this.buildComp('password', {
      label: password,
      name: 'password'
    }), this.buildComp('password', {
      label: repeat,
      name: 'password-repeat'
    }), this.buildComp('text', {
      label: name,
      name: 'name'
    }), this.buildComp('gender', {
      label: gender,
      name: 'gender'
    }), this.buildComp('date', {
      label: birthdate,
      name: 'birthdate'
    }), this.buildComp('button', {
      label: signup
    }), a({
      href: '/login'
    }, login));
  }
});
