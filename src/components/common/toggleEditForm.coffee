React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

Utils = require '../../util/objectTools'

{ div, form, button, h3 } = React.DOM

module.exports = React.createClass

  displayName: 'toggleEditForm'

  mixins: [React.addons.LinkedStateMixin, ReactIntl]

  propTypes:
    id: React.PropTypes.string
    title: React.PropTypes.string
    defaults: React.PropTypes.object
    submitCallback: React.PropTypes.func

  childContextTypes:
    editable: React.PropTypes.bool

  getInitialState: (props) ->
    props = props or @props
    ret = editable: false
    if props.defaults
      ret = _.extend ret, Utils.flatten values: props.defaults
    ret

  componentWillReceiveProps: (next) ->
    if @props.defaults isnt next.defaults
      @setState @getInitialState next

  getChildContext: ->
    editable: @state.editable

  toggleEditable: ->
    @setState editable: not @state.editable

  handleClick: (e) ->
    e.preventDefault()
    if @state.editable
      @handleSubmit()
    @toggleEditable()

  handleSubmit: ->
    t = Utils.unflatten @state
    @props.submitCallback? t.values

  render: ->
    _this = @
    tglEdFrm = 'comp-toggleEditForm'
    msg = @getIntlMessage 'edit'
    if @state.editable
      tglEdFrm += ' editable'
      msg = @getIntlMessage 'save'

    # checkedLink: _this.linkState 'values.' + child.props.name

    enhacedChildren = React.Children.map @props.children, (child) ->
      React.addons.cloneWithProps child,
        editable: _this.state.editable
        valueLink: _this.linkState 'values.' + child.props.name

    form id: @props.id, onSubmit: @handleSubmit, className: tglEdFrm,
      div className: 'field-set',
        div className: 'header',
          h3 {}, @props.title
          button className: 'toggleButton', onClick: @handleClick, msg
        enhacedChildren
