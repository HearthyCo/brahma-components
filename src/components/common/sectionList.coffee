React = require 'react'
ReactIntl = require '../../mixins/ReactIntl'

{ div, img, span, a } = React.DOM

module.exports = React.createClass

  displayName: 'sectionlist'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    title: React.PropTypes.string.isRequired
    url: React.PropTypes.string
    advice: React.PropTypes.bool
    onViewMoreClick: React.PropTypes.func


  render: ->

    opts =
      className: 'view-more section-view-more'
      href: @props.url
      key: 'moreEntries'
      onClick: @props.onViewMoreClick

    if @props.children?.length
      body = [
        div className: 'section',key: 'Entries',
          @props.children
        a opts,
          span className: 'icon icon-advice' if not @props.advice
          @getIntlMessage 'view-more'
      ]

    else
      body = [
        div className: 'no-entries', key: 'noEntries',
          @getIntlMessage('you-do-not-have') +
            ' ' + @props.title + ' ' + @getIntlMessage('for-now')
      ]

    div id: @props.id, className: 'comp-sectionlist',
      div className: 'section-title',
        @props.title
      body
