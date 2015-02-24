React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

{ div, form, button, h3 } = React.DOM

module.exports = React.createClass

  displayName: 'toggleEditForm'

  mixins: [React.addons.LinkedStateMixin, ReactIntl]

  childContextTypes:
    editable: React.PropTypes.bool

  getInitialState: ->
    editable: false

  getChildContext: ->
    editable: @state.editable

  toggleEditable: ->
    @setState editable: not @state.editable

  handleClick: (e) ->
    e.preventDefault()
    @toggleEditable()

  render: ->
    _this = @
    tglEdFrm = 'comp-toggleEditForm'
    msg = @getIntlMessage 'edit'
    if @state.editable
      tglEdFrm += ' editable'
      msg = @getIntlMessage 'save'

    enhacedChildren = React.Children.map @props.children, (child) ->
      React.addons.cloneWithProps child,
        editable: _this.state.editable
        valueLink: _this.linkState child.props.name

    form action: @props.action, className: tglEdFrm,
      div className: 'field-set',
        div className: 'header',
          h3 {}, @props.title
          button className: 'toggleButton', onClick: @handleClick, msg
        enhacedChildren