var ObjectTools, React, ReactIntl, TextForm, UserActions, a, button, form, _, _ref;

React = require('react/addons');

ReactIntl = require('react-intl');

_ = require('underscore');

TextForm = React.createFactory(require('../common/form/text'));

_ref = React.DOM, form = _ref.form, a = _ref.a, button = _ref.button;

UserActions = require('../../actions/UserActions');

ObjectTools = require('../../util/objectTools');

module.exports = React.createClass({
  mixins: [React.addons.LinkedStateMixin, ReactIntl],
  handleSubmit: function(e) {
    var obj;
    e.preventDefault();
    obj = _.extend({}, this.state);
    return UserActions.login(obj);
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
      case 'password':
        return TextForm(obj);
      case 'button':
        return button({
          id: opt.name
        }, opt.label);
    }
  },
  render: function() {
    var login, password, username;
    username = this.getIntlMessage('username');
    password = this.getIntlMessage('password');
    login = this.getIntlMessage('login');
    return form({
      action: this.props.action,
      onSubmit: this.handleSubmit,
      className: 'comp-loginForm'
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
