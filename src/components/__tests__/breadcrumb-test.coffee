jest.dontMock '../common/breadcrumb'
jest.dontMock '../../util/breadcrumber'
jest.dontMock '../../util/objectTools'

describe 'Breadcrumb', ->
  it 'return breadcrumb for allergies', ->
    Intl = require 'intl'
    messages = require '../../../../hearthy-client/app/intl/es-ES.json'

    React = require 'react/addons'
    breadcrumb = require '../common/breadcrumb'
    Breadcrumber = require '../../util/breadcrumber'

    TestUtils = React.addons.TestUtils

    crumbs = null
    bc = Breadcrumber.allergy()
    values = { id: '1' }

    obj = TestUtils.renderIntoDocument React.createElement breadcrumb,
        breadcrumb: bc, values: values, messages: messages

    crumbs = TestUtils.scryRenderedDOMComponentsWithClass obj, 'crumb'

    crumbsLinks = []
    for crumb in crumbs
      crumbsLinks.push crumb.getDOMNode().href

    links = [ 'file:///home', 'file:///allergies', 'file:///allergies/1' ]

    expect(links).toEqual(crumbsLinks)

  it 'return breadcrumb for session state', ->
    Intl = require 'intl'
    messages = require '../../../../hearthy-client/app/intl/es-ES.json'

    React = require 'react/addons'
    breadcrumb = require '../common/breadcrumb'
    Breadcrumber = require '../../util/breadcrumber'

    TestUtils = React.addons.TestUtils

    crumbs = null
    bc = Breadcrumber.sessions()
    values = { state: 'closed' }

    obj = TestUtils.renderIntoDocument React.createElement breadcrumb,
        breadcrumb: bc, values: values, messages: messages

    crumbs = TestUtils.scryRenderedDOMComponentsWithClass obj, 'crumb'

    crumbsLinks = []
    for crumb in crumbs
      crumbsLinks.push crumb.getDOMNode().href

    links = [ 'file:///home', 'file:///sessions/closed' ]

    expect(links).toEqual(crumbsLinks)