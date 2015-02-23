React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

{ div, form, button, h3 } = React.DOM

module.exports = React.createClass

  displayName: 'toggleEditForm'

  mixins: [ReactIntl]

  render: ->

    tglEdFrm = 'comp-toggleEditForm'

    form action: @props.action, className: tglEdFrm,
      div className: 'field-set',
        div className: 'header',
          h3 {}, @props.title
          button className: 'toggleButton',
            @getIntlMessage 'edit'
        @props.children