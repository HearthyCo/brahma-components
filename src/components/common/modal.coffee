React = require 'react'
ReactIntl = require '../../mixins/ReactIntl'

ModalActions = require '../../actions/ModalActions'

{ span, div } = React.DOM

module.exports = React.createClass

  displayName: 'modal'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    content: React.PropTypes.node.isRequired
    onClose: React.PropTypes.func

  onClose: ->
    if @props.onClose
      @props.onClose()

  render: ->
    div id: @props.id, className: 'comp-modal',
      div className: 'modal-close', onClick: @onClose,
        span className: 'icon icon-cross'
      div className: 'modal-content',
        @getIntlMessage @props.content