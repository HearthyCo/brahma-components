var ButtonForm, DateForm, GenderForm, ObjectTools, React, TextForm, UserActions, a, form, _, _ref;

React = require('react');

_ = require('underscore');

TextForm = React.createFactory(require('../components/form/text'));

DateForm = React.createFactory(require('../components/form/date'));

GenderForm = React.createFactory(require('../components/form/gender'));

ButtonForm = React.createFactory(require('../components/form/button'));

_ref = React.DOM, form = _ref.form, a = _ref.a;

UserActions = require('../actions/UserActions');

ObjectTools = require('../util/objectTools');

module.exports = React.createClass({
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
  handleChange: function(key, val) {
    var newState;
    newState = _.extend({}, this.state);
    ObjectTools.indexStrSet(newState, key, val);
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
    return form({
      action: 'signup',
      onSubmit: this.handleSubmit
    }, this.buildComp('text', {
      label: 'Username',
      name: 'login'
    }), this.buildComp('email', {
      label: 'Email',
      name: 'email'
    }), this.buildComp('password', {
      label: 'Password',
      name: 'password'
    }), this.buildComp('password', {
      label: 'Repeat',
      name: 'password-repeat'
    }), this.buildComp('text', {
      label: 'Name',
      name: 'name'
    }), this.buildComp('gender', {
      label: 'Gender',
      name: 'gender'
    }), this.buildComp('date', {
      label: 'Birthdate',
      name: 'birthdate'
    }), this.buildComp('button', {
      label: 'Sign up'
    }), a({
      href: '/login'
    }, 'Login'));
  }
});
