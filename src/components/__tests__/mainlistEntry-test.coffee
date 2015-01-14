jest.dontMock '../common/iconbadge'
jest.dontMock '../common/mainlistEntry'
jest.dontMock '../common/form/text'
jest.dontMock '../../util/objectTools'

describe 'Mainlist Entry', ->
  it 'toggles "is-expanded" class on click', ->
    React = require 'react/addons'
    MainlistEntry = require '../common/mainlistEntry'
    TestUtils = React.addons.TestUtils

    div = TestUtils.renderIntoDocument React.createElement MainlistEntry,
      {label: 'Test Entry', icon: 'icon.png', value: 3},
    button = TestUtils.findRenderedDOMComponentWithClass div, 'entry-button'
    content = TestUtils.findRenderedDOMComponentWithClass div, 'entry-content'

    expect(content.props.className).not.toContain('is-expanded')
    TestUtils.Simulate.click button
    expect(content.props.className).toContain('is-expanded')
    TestUtils.Simulate.click button
    expect(content.props.className).not.toContain('is-expanded')
