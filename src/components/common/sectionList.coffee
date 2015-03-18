React = require 'react'
ReactIntl = require 'react-intl'

{ div, img, span, a } = React.DOM

module.exports = React.createClass

  displayName: 'sectionlist'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    title: React.PropTypes.string.isRequired
    url: React.PropTypes.string.isRequired
    advice: React.PropTypes.bool

  render: ->
    div id: @props.id, className: 'comp-sectionlist',
      div className: 'section-title',
        @props.title
      div className: 'section',
        @props.children
      a className: 'view-more section-view-more', href: @props.url,
        span className: 'icon icon-advice' if not @props.advice
        @getIntlMessage 'view-more'
