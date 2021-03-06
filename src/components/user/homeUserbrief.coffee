React = require 'react'
ReactIntl = require '../../mixins/ReactIntl'
Utils = require '../../util/frontendUtils'


{ div, img } = React.DOM

module.exports = React.createClass

  displayName: 'homeUserbrief'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    user: React.PropTypes.object.isRequired

  render: ->
    _this = @
    fullname = Utils.fullName @props.user

    birthdate = if @props.user.birthdate
      @formatDate @props.user.birthdate, 'dateonly'

    div id: @props.id, className: 'comp-homeUserbrief',
      div className: 'name', fullname
      div className: 'birth',
        @getIntlMessage('birth'), ': '
        birthdate
      div className: 'gender', @getIntlMessage @props.user.gender.toLowerCase()
