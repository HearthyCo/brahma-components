var ButtonForm, React, ReactIntl, TextForm, UserActions, a, form, _ref;

React = require('react');

ReactIntl = require('react-intl');

TextForm = React.createFactory(require('../components/form/text'));

ButtonForm = React.createFactory(require('../components/form/button'));

_ref = React.DOM, form = _ref.form, a = _ref.a;

UserActions = require('../actions/UserActions');

module.exports = React.createClass({
  mixins: [ReactIntl],
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
    var login, password, username;
    username = this.getIntlMessage('username');
    password = this.getIntlMessage('password');
    login = this.getIntlMessage('login');
    return form({
      action: this.props.action,
      onSubmit: this.handleSubmit
    }, this.buildComp('text', {
      label: username,
      name: 'login'
    }), this.buildComp('password', {
      label: password,
      name: 'password'
    }), this.buildComp('button', {
      label: login
    }), a({
      href: '/register'
    }, 'Register'));
  }
});
