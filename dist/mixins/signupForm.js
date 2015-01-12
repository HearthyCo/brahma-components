var ButtonForm, DateForm, GenderForm, ObjectTools, React, ReactIntl, TextForm, UserActions, a, form, _, _ref;

React = require('react');

ReactIntl = require('react-intl');

_ = require('underscore');

TextForm = React.createFactory(require('../components/form/text'));

DateForm = React.createFactory(require('../components/form/date'));

GenderForm = React.createFactory(require('../components/form/gender'));

ButtonForm = React.createFactory(require('../components/form/button'));

_ref = React.DOM, form = _ref.form, a = _ref.a;

UserActions = require('../actions/UserActions');

ObjectTools = require('../util/objectTools');

module.exports = React.createClass({
  mixins: [ReactIntl],
  handleSubmit: function(e) {
    var birthdate, obj;
    e.preventDefault();
    obj = _.extend({}, this.state);
    birthdate = ('0000' + (obj.birthdate.year || '')).substr(-4) + '-';
    birthdate += ('00' + (obj.birthdate.month || '')).substr(-2) + '-';
    birthdate += ('00' + (obj.birthdate.day || '')).substr(-2);
    obj.birthdate = birthdate;
    console.log(obj);
    return UserActions.register(obj);
  },
  getInitialState: function() {
    return {};
  },
  handleChange: function(key, val) {
    var newState;
    newState = _.extend({}, this.state);
    ObjectTools.indexStrSet(newState, key, val);
    console.log('New state:', newState);
    return this.setState(newState);
  },
  buildComp: function(type, opt) {
    switch (type) {
      case 'text':
        return TextForm({
          id: opt.name,
          label: opt.label,
          name: opt.name,
          type: type,
          callback: this.handleChange,
          value: this.state[opt.name]
        });
      case 'email':
        return TextForm({
          id: opt.name,
          label: opt.label,
          name: opt.name,
          type: type,
          callback: this.handleChange,
          value: this.state[opt.name]
        });
      case 'password':
        return TextForm({
          id: opt.name,
          label: opt.label,
          name: opt.name,
          type: type,
          callback: this.handleChange,
          value: this.state[opt.name]
        });
      case 'gender':
        return GenderForm({
          id: opt.name,
          label: opt.label,
          name: opt.name,
          callback: this.handleChange,
          value: this.state[opt.name]
        });
      case 'date':
        return DateForm({
          id: opt.name,
          label: opt.label,
          name: opt.name,
          callback: this.handleChange,
          value: this.state[opt.name]
        });
      case 'button':
        return ButtonForm({
          id: opt.name,
          label: opt.label
        });
    }
  },
  render: function() {
    var birthdate, email, gender, name, password, repeat, signup, username;
    username = this.getIntlMessage('username');
    email = this.getIntlMessage('email');
    password = this.getIntlMessage('password');
    repeat = this.getIntlMessage('repeat');
    name = this.getIntlMessage('name');
    gender = this.getIntlMessage('gender');
    birthdate = this.getIntlMessage('birthdate');
    signup = this.getIntlMessage('signup');
    return form({
      action: 'signup',
      onSubmit: this.handleSubmit
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
    }, 'Login'));
  }
});
