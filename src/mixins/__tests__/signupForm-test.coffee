jest.dontMock '../signupForm'
jest.dontMock '../../components/form/text'
jest.dontMock '../../components/form/input'
jest.dontMock '../../components/form/gender'
jest.dontMock '../../components/form/radio'
jest.dontMock '../../components/form/date'
jest.dontMock '../../components/form/select'
jest.dontMock '../../components/form/button'
jest.dontMock '../../util/objectTools'

describe 'Signup Form', ->
  it 'triggers user:register event on submit', ->
    React = require 'react/addons'
    LoginForm = require '../signupForm'
    TestUtils = React.addons.TestUtils

    form = TestUtils.renderIntoDocument React.createElement LoginForm
    inputs = TestUtils.scryRenderedDOMComponentsWithTag form, 'input'
    selects = TestUtils.scryRenderedDOMComponentsWithTag form, 'select'
    submit = TestUtils.findRenderedDOMComponentWithTag form, 'button'

    # Set inputs
    for input in inputs
      node = input.getDOMNode()
      if node.type == 'radio'
        if node.value == 'MALE'
          node.checked = true
          TestUtils.Simulate.change input, target: node
      else
        node.value = node.name
        TestUtils.Simulate.change input, target: node

    # Set date
    for select in selects
      node = select.getDOMNode()

      switch node.name
        when 'day' then node.value = '6'
        when 'month' then node.value = '8'
        when 'year' then node.value = '1987'
      TestUtils.Simulate.change select, target: node

    TestUtils.Simulate.submit submit

    UserActions = require '../../actions/UserActions'
    expect(UserActions.register.mock.calls[0][0]).toEqual({
      login: 'login'
      password: 'password'
      name: 'name'
      email: 'email'
      gender: 'MALE'
      birthdate: '1987-08-06'
    })

