var ButtonForm, React, TextForm, UserActions, a, form, _ref;

React = require('react');

TextForm = React.createFactory(require('../components/form/text'));

ButtonForm = React.createFactory(require('../components/form/button'));

_ref = React.DOM, form = _ref.form, a = _ref.a;

UserActions = require('../actions/UserActions');

module.exports = React.createClass({
  handleSubmit: function(e) {
    e.preventDefault();
    return UserActions.login(this.getFormValue());
  },
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
  buildComp: function(type, opt) {
    switch (type) {
      case 'text':
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
      case 'button':
        return ButtonForm({
          id: opt.name,
          label: opt.label
        });
    }
  },
  render: function() {
    return form({
      action: this.props.action,
      onSubmit: this.handleSubmit
    }, this.buildComp('text', {
      label: 'Username',
      name: 'login'
    }), this.buildComp('password', {
      label: 'Password',
      name: 'password'
    }), this.buildComp('button', {
      label: 'Sign up'
    }), a({
      href: '/register'
    }, 'Register'));
  }
});
