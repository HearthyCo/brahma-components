React = require 'react/addons'
ReactIntl = require '../../mixins/ReactIntl'
_ = require 'underscore'

Utils = require '../../util/objectTools'

{ div, form, button, h3, span } = React.DOM

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
      @replaceState @getInitialState next

  getChildContext: ->
    editable: @state.editable

  toggleEditable: ->
    @setState editable: not @state.editable

  handleSave: (e) ->
    e.preventDefault()
    if @state.editable
      @handleSubmit()
    @toggleEditable()

  handleCancel: (e) ->
    e.preventDefault()
    @replaceState @getInitialState()
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

    enhacedChildren = React.Children.map @props.children, (child) ->
      # Enhaced properties
      props = editable: _this.state.editable

      # Elements don't allow both methods together
      switch child.type.linkType
        when 'checked'
          props.checkedLink = _this.linkState 'values.' + child.props.name
        else
          props.valueLink = _this.linkState 'values.' + child.props.name

      # Clone them with these properties
      React.addons.cloneWithProps child, props

    form id: @props.id, onSubmit: @handleSubmit, className: tglEdFrm,
      div className: 'field-set',
        div className: 'header',
          h3 {}, @props.title
          button className: 'toggleButton', onClick: @handleSave, msg
          if @state.editable
            div className: 'cancel', onClick: @handleCancel,
              span className: 'icon icon-cross'
              span {}, @getIntlMessage 'cancel'
        enhacedChildren
