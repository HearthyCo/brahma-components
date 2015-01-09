jest.dontMock '../loginForm'
jest.dontMock '../../components/form/input'
jest.dontMock '../../components/form/text'
jest.dontMock '../../components/form/button'
jest.dontMock '../../util/objectTools'

describe 'Login Form', ->
  it 'triggers user:login event on submit', ->
    React = require 'react/addons'
    LoginForm = require '../loginForm'
    TestUtils = React.addons.TestUtils

    form = TestUtils.renderIntoDocument React.createElement LoginForm
    inputs = TestUtils.scryRenderedDOMComponentsWithTag form, 'input'
    submit = TestUtils.findRenderedDOMComponentWithTag form, 'button'

    login = 'testUser1'
    for input in inputs
      node = input.getDOMNode()
      node.value = login
      TestUtils.Simulate.change input, target: node

    TestUtils.Simulate.submit submit

    UserActions = require '../../actions/UserActions'
    expect(UserActions.login.mock.calls[0][0]).toEqual({
      login: login
      password: login
    })

