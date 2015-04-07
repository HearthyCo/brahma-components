React = require 'react'
ReactIntl = require 'react-intl'

{ div, img, span } = React.DOM

module.exports = React.createClass

  displayName: 'userCompleteBrief'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    user: React.PropTypes.object.isRequired

  render: ->
    avatar = @props.user.avatar or '/res/images/default-avatar.png'
    _this = @
    fullname = ['name', 'surname1', 'surname2']
      .map (f) -> _this.props.user[f]
      .filter (v) -> v
      .join ' '
    fulladdress = ['street', 'city', 'postalcode']
      .map (f) -> _this.props.user.meta?.address?[f]
      .filter (v) -> v
      .join ', '
    fulladdress = fulladdress or 'Calle benito garcia de fuente nº2 3ºB, 320001'
    phone = @props.user.meta?.address?.phone or '9XX XXX XXX'      # fake params
    birthdate = if @props.user.birthdate
      @formatDate @props.user.birthdate, 'dateonly'

    div id: @props.id, className: 'comp-usercompletebrief',
      img className: 'avatar', src: avatar
      div className: 'brief-info',
        div className: 'name',
          span className: 'brief-value', fullname
        div className: 'birth',
          span className: 'brief-key', @getIntlMessage('birth'), ': '
          span className: 'brief-value', birthdate
        div className: 'gender',
          span className: 'brief-key', @getIntlMessage('gender'), ': '
          span className: 'brief-value', @props.user.gender
        div className: 'address',
          span className: 'icon icon-location'
          span className: 'brief-value', fulladdress
        div className: 'phone',
          span className: 'icon icon-phone'
          span className: 'brief-value', phone
        div className: 'email',
          span className: 'icon icon-email'
          span className: 'brief-value', @props.user.email
