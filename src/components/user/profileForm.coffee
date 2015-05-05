React = require 'react/addons'
ReactIntl = require '../../mixins/ReactIntl'
_ = require 'underscore'

AlertStore = require '../../stores/AlertStore'
UserActions = require '../../actions/UserActions'

TextForm = React.createFactory require '../common/form/text'
DateForm = React.createFactory require '../common/form/date'
GenderForm = React.createFactory require '../common/form/gender'

{ div, form, a, button, span } = React.DOM

module.exports = React.createClass

  displayName: 'profileForm'

  mixins: [React.addons.LinkedStateMixin, ReactIntl]

  propTypes:
    showRegister: React.PropTypes.bool

  handleSubmit: (e) ->
    e.preventDefault()
    obj = _.extend {}, @state
    # Do your form post-processing here
    UserActions.save obj

  getDefaultProps: () ->
    showRegister: true

  getInitialState: () ->
    return error: AlertStore.getFormAlert('UserLogin', 'error') or false

  componentWillReceiveProps: -> #(next) ->
    @setState @getInitialState()

  buildComp: (type, opt) ->
    obj =
      id: opt.name
      label: opt.label
      icon: opt.icon
      name: opt.name
      type: type
      placeholder: opt.placeholder
      valueLink: @linkState opt.name
      error: false
      required: true

    if @state.error
      obj.error = ( @state.error.fields.indexOf(opt.name) > -1 )

    switch type
      when 'text' then TextForm obj
      when 'date' then DateForm obj
      when 'gender' then GenderForm obj
      when 'button' then button
        id: opt.name
        , opt.label

  render: ->
    name = @getIntlMessage 'name'
    surname1 = @getIntlMessage 'surname-1'
    surname2 = @getIntlMessage 'surname-2'
    birthdate = @getIntlMessage 'birthdate'
    gender = @getIntlMessage 'gender'
    next = @getIntlMessage 'continue'

    _className = 'comp-profileDataForm'
    _className += ' error' if @state.error

    userName =
      label: name
      name: 'name'
      placeholder: name

    userSurname1 =
      label: surname1
      name: 'surname1'
      placeholder: surname1

    userSurname2 =
      label: surname2
      name: 'surname2'
      placeholder: surname2

    birthdate =
      label: birthdate
      name: 'birthdate'

    gender =
      gender: gender
      name: 'gender'

    form
      action: @props.action or "post"
      onSubmit: @handleSubmit
      className: _className,
      @buildComp 'text', userName
      @buildComp 'text', userSurname1
      @buildComp 'text', userSurname2
      @buildComp 'date', birthdate
      @buildComp 'gender', gender

      if @state.error
        div className: 'error-content',
          span className: 'icon icon-cross'
          span {},
            @getIntlMessage @state.error.content

      @buildComp 'button', label: next