var ButtonForm, DateForm, GenderForm, React, TextForm, UserActions, a, form, _ref;

React = require('react');

TextForm = React.createFactory(require('../components/form/text'));

DateForm = React.createFactory(require('../components/form/date'));

GenderForm = React.createFactory(require('../components/form/gender'));

ButtonForm = React.createFactory(require('../components/form/button'));

_ref = React.DOM, form = _ref.form, a = _ref.a;

UserActions = require('../actions/UserActions');

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
  buildComp: function(type, opt) {
    switch (type) {
      case 'text':
        return TextForm({
          id: opt.name,
          label: opt.label,
          name: opt.name,
          type: type
        });
      case 'email':
        return TextForm({
          id: opt.name,
          label: opt.label,
          name: opt.name,
          type: type
        });
      case 'password':
        return TextForm({
          id: opt.name,
          label: opt.label,
          name: opt.name,
          type: type
        });
      case 'gender':
        return GenderForm({
          id: opt.name,
          label: opt.label,
          name: opt.name
        });
      case 'date':
        return DateForm({
          id: opt.name,
          label: opt.label,
          name: opt.name
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
      onChange: this.handleChange,
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
