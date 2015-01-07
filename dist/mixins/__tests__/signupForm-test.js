jest.dontMock('../signupForm');

jest.dontMock('../../components/form/text');

jest.dontMock('../../components/form/gender');

jest.dontMock('../../components/form/date');

jest.dontMock('../../components/form/button');

describe('Signup Form', function() {
  return it('triggers user:register event on submit', function() {
    var LoginForm, React, TestUtils, UserActions, form, input, inputs, node, submit, _i, _len;
    React = require('react/addons');
    LoginForm = require('../signupForm');
    TestUtils = React.addons.TestUtils;
    form = TestUtils.renderIntoDocument(React.createElement(LoginForm));
    inputs = TestUtils.scryRenderedDOMComponentsWithTag(form, 'input');
    submit = TestUtils.findRenderedDOMComponentWithTag(form, 'button');
    for (_i = 0, _len = inputs.length; _i < _len; _i++) {
      input = inputs[_i];
      node = input.getDOMNode();
      node.value = node.name;
    }
    TestUtils.Simulate.submit(submit);
    UserActions = require('../../actions/UserActions');
    return expect(UserActions.register.mock.calls[0][0]).toEqual({
      login: 'login',
      password: 'password',
      name: 'name',
      email: 'email',
      gender: 'gender',
      birthdate: 'birthdate'
    });
  });
});
