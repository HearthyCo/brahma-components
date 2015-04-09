React = require 'react'
ReactIntl = require '../../mixins/ReactIntl'

{ div, span, h2 } = React.DOM

module.exports = React.createClass

  displayName: 'historyentry'

  mixins: [ReactIntl]

  render: ->

    # fake content
    code = '(000714) '
    title = 'Afrontamiento familiar comprometido'
    historyEntryText =
      '''
      Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad
      quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea
      consequat. Duis aute irure dolor in reprehenderit in voluptate
      cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat
      proident, sunt in culpa qui officia deserunt mollit anim id est.
      '''
    # end fake content

    div id: @props.id, className: 'comp-historyentry',
      h2 className: 'history-header',
        span className: 'history-code', @props.history?.code or code
        span className: 'history-title', @props.history?.title or title
      div className: 'history-body',
        @props.history?.content or historyEntryText

