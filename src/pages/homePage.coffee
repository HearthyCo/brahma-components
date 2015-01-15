React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

MainlistEntry = React.createFactory require '../components/common/mainlistEntry'
SessionList = React.createFactory require '../components/common/sessionList'
IconButton = React.createFactory require '../components/common/iconbutton'

{ div } = React.DOM

icon = 'https://cdn0.iconfinder.com/data/icons/feather/96/clock-128.png'

module.exports = React.createClass

  mixins: [ReactIntl]

  getInitialState: ->
    sessions:
      programmed: [
        {id: 1, title: 'Lorem', startDate: new Date()}
        {id: 2, title: 'Ipsum', startDate: new Date()}
      ]
      underway: [
        {id: 3, title: 'Dolor', startDate: new Date()}
        {id: 4, title: 'Sit', startDate: new Date()}
      ]
      closed: [
        {id: 5, title: 'Amet', startDate: new Date()}
        {id: 6, title: 'Completar', startDate: new Date()}
      ]

  render: ->
    sessions = []
    for key, entries of @state.sessions
      opts =
        title: @getIntlMessage(key)
        key: key
        url: '/sessions/' + key
        sessions: entries
      sessions.push SessionList opts

    div className: 'page-home',
      MainlistEntry label: @getIntlMessage('sessions'), value: 2, icon: icon,
        sessions