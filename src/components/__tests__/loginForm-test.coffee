jest.dontMock '../user/loginForm'
jest.dontMock '../common/form/text'
jest.dontMock '../../util/objectTools'

describe 'Login Form', ->
  it 'triggers user:login event on submit', ->
    # Traslate set for test
    Intl = require 'intl'
    messages = require '../../../../hearthy-client/app/locales/es-ES.json'

    React = require 'react/addons'
    LoginForm = require '../user/loginForm'
    TestUtils = React.addons.TestUtils


    form = TestUtils.renderIntoDocument React.createElement LoginForm,
      { messages: messages }
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

  it 'change language on select other language', ->
    # Traslate set for test
    Intl = require 'intl'
    messages = require '../../../../hearthy-client/app/locales/en-US.json'

    React = require 'react/addons'
    LoginForm = require '../user/loginForm'
    TestUtils = React.addons.TestUtils


    form = TestUtils.renderIntoDocument React.createElement LoginForm,
      { messages: messages }

    labels = TestUtils.scryRenderedDOMComponentsWithClass form, 'label-form'

    labelsUpdated = []
    for label in labels
      labelsUpdated.push label.getDOMNode().innerHTML

    labelsTranslated = [
      messages.username,
      messages.password
    ]

    expect(labelsTranslated).toEqual(labelsUpdated)

