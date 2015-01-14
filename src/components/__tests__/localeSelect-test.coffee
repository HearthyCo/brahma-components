jest.dontMock '../common/intl/localeSelect'
jest.dontMock '../../util/objectTools'

describe 'Locale Select', ->
  it 'changes language on change', ->
    React = require 'react/addons'
    LocaleSelect = require '../common/intl/localeSelect'
    TestUtils = React.addons.TestUtils

    select = null

    React.withContext
      availableLocales: [ 'en-US', 'es-ES' ]
      locale: 'es-ES'
      messages: { 'es-ES': {} },
      ->
        obj = TestUtils.renderIntoDocument React.createElement LocaleSelect, {}
        select = TestUtils.findRenderedDOMComponentWithTag obj, 'select'

    node = select.getDOMNode()
    node.value = 'en-US'

    TestUtils.Simulate.change select, target: node

    IntlActions = require '../../actions/IntlActions'
    expect(IntlActions.requestChange.mock.calls[0][0]).toEqual 'en-US'