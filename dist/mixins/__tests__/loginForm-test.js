jest.dontMock('../loginForm');

jest.dontMock('../../components/form/input');

jest.dontMock('../../components/form/button');

describe('Login Form', function() {
  return it('triggers user:login event on submit', function() {
    var LoginForm, React, TestUtils, UserActions, form, inputs, login, submit;
    React = require('react/addons');
    LoginForm = require('../loginForm');
    TestUtils = React.addons.TestUtils;
    form = TestUtils.renderIntoDocument(React.createElement(LoginForm));
    inputs = TestUtils.scryRenderedDOMComponentsWithTag(form, 'input');
    submit = TestUtils.findRenderedDOMComponentWithTag(form, 'button');
    login = 'testUser1';
    inputs[0].getDOMNode().value = inputs[1].getDOMNode().value = login;
    TestUtils.Simulate.submit(submit);
    UserActions = require('../../actions/UserActions');
    return expect(UserActions.login.mock.calls[0][0]).toEqual({
      login: login,
      password: login
    });
  });
});
