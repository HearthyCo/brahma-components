jest.dontMock '../user/signupForm'
jest.dontMock '../common/form/text'
jest.dontMock '../common/form/gender'
jest.dontMock '../common/form/date'
jest.dontMock '../../util/objectTools'

describe 'Signup Form', ->
  it 'triggers user:register event on submit', ->
    # Traslate set for test
    Intl = require 'intl'
    messages = require '../../../../hearthy-client/app/locales/es-ES.json'

    React = require 'react/addons'
    SignupForm = require '../user/signupForm'
    TestUtils = React.addons.TestUtils


    form = TestUtils.renderIntoDocument React.createElement SignupForm,
      { messages: messages }
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

  it 'change language on select other language', ->
    # Traslate set for test
    Intl = require 'intl'
    messages = require '../../../../hearthy-client/app/locales/en-US.json'

    React = require 'react/addons'
    SignupForm = require '../user/signupForm'
    TestUtils = React.addons.TestUtils


    form = TestUtils.renderIntoDocument React.createElement SignupForm,
      { messages: messages }

    labels = TestUtils.scryRenderedDOMComponentsWithClass form, 'label-form'

    labelsUpdated = []
    for label in labels
      labelsUpdated.push label.getDOMNode().innerHTML

    labelsTranslated = [
      messages.username,
      messages.email,
      messages.password,
      messages.repeat,
      messages.name,
      messages.gender,
      messages.birthdate
    ]

    expect(labelsTranslated).toEqual(labelsUpdated)
