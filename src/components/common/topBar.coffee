React = require 'react/addons'
_ = require 'underscore'

{ header, div, a, span } = React.DOM

PageStore = require '../../stores/PageStore'
BreadcrumbStore = require '../../stores/BreadcrumbStore'
PageActions = require '../../actions/PageActions'

module.exports = React.createClass

  displayName: 'topBar'

  handleUp: ->
    #url = BreadcrumbStore.getUp()
    #PageActions.navigate url.link()
    BreadcrumbStore.goUp()

  render: ->
    onBackArrowPages = ['homePage', 'loginPage', 'signupPage']
    page = PageStore.getPage()

    header className: 'comp-topBar',
      div className: 'topBar-wrapper',
        div className: 'left-box',
          div className: 'menuBar',
            if onBackArrowPages.indexOf(page.current.displayName) < 0
              a onClick: @handleUp,
                span className: 'icon icon-arrow-left'
        div className: 'center-box',
          a href: '/',
            div className: 'logoBar'
        div className: 'right-box',
          div className: 'iconBar'