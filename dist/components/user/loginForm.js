var ObjectTools, React, TextForm, UserActions, a, button, form, _, _ref;

React = require('react/addons');

_ = require('underscore');

TextForm = React.createFactory(require('../common/form/text'));

_ref = React.DOM, form = _ref.form, a = _ref.a, button = _ref.button;

UserActions = require('../../actions/UserActions');

ObjectTools = require('../../util/objectTools');

module.exports = React.createClass({
  mixins: [React.addons.LinkedStateMixin],
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
