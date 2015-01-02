var ButtonForm, InputForm, React, form;

React = require('react');

InputForm = React.createFactory(require("../components/form/input"));

ButtonForm = React.createFactory(require("../components/form/button"));

form = React.DOM.form;

module.exports = React.createClass({
  render: function() {
    return form({
      action: this.props.action
    }, InputForm({
      fieldName: "Email",
      type: "email"
    }), InputForm({
      fieldName: "Password",
      type: "password"
    }), ButtonForm({
      fieldName: "Login"
    }));
  }
});
