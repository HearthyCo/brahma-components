jest.dontMock '../loginForm'
jest.dontMock '../../components/form/input'
jest.dontMock '../../components/form/button'

describe 'Login Form', ->
  it 'triggers user:login event on submit', ->
    React = require 'react/addons'
    LoginForm = require '../loginForm'
    TestUtils = React.addons.TestUtils;

    form = TestUtils.renderIntoDocument React.createElement LoginForm
    inputs = TestUtils.scryRenderedDOMComponentsWithTag form, 'input'
    submit = TestUtils.findRenderedDOMComponentWithTag form, 'button'

    inputs[0].getDOMNode().value = inputs[1].getDOMNode().value = login = 'testUser1'
    TestUtils.Simulate.submit submit

    UserActions = require '../../actions/UserActions'
    expect(UserActions.login.mock.calls[0][0]).toEqual({
      login: login
      password: login
    })

