var DateForm, GenderForm, ObjectTools, React, TextForm, UserActions, a, button, form, _, _ref;

React = require('react/addons');

_ = require('underscore');

TextForm = React.createFactory(require('../common/form/text'));

DateForm = React.createFactory(require('../common/form/date'));

GenderForm = React.createFactory(require('../common/form/gender'));

_ref = React.DOM, form = _ref.form, a = _ref.a, button = _ref.button;

UserActions = require('../../actions/UserActions');

ObjectTools = require('../../util/objectTools');

module.exports = React.createClass({
  mixins: [React.addons.LinkedStateMixin],
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
    return form({
      action: 'signup',
      onSubmit: this.handleSubmit,
      className: 'comp-signupForm'
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
