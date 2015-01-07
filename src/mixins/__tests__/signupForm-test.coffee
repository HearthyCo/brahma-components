jest.dontMock '../signupForm'
jest.dontMock '../../components/form/text'
jest.dontMock '../../components/form/gender'
jest.dontMock '../../components/form/date'
jest.dontMock '../../components/form/button'

describe 'Signup Form', ->
  it 'triggers user:register event on submit', ->
    React = require 'react/addons'
    LoginForm = require '../signupForm'
    TestUtils = React.addons.TestUtils

    form = TestUtils.renderIntoDocument React.createElement LoginForm
    inputs = TestUtils.scryRenderedDOMComponentsWithTag form, 'input'
    submit = TestUtils.findRenderedDOMComponentWithTag form, 'button'

    # TODO: Cambiame por valores validos con los nuevos controles
    for input in inputs
      node = input.getDOMNode()
      node.value = node.name
    TestUtils.Simulate.submit submit

    UserActions = require '../../actions/UserActions'
    expect(UserActions.register.mock.calls[0][0]).toEqual({
      # TODO: Cambiame aqui tambien
      login: 'login'
      password: 'password'
      name: 'name'
      email: 'email'
      gender: 'gender'
      birthdate: 'birthdate'
    })

