React = require 'react'
ReactIntl = require '../../mixins/ReactIntl'

{ a, img, span, div } = React.DOM

UserBrief = React.createFactory require '../user/userBrief'

module.exports = React.createClass

  displayName: 'historyBrief'

  mixins: [ReactIntl]

  propTypes:
    id: React.PropTypes.string
    profile: React.PropTypes.object
    history: React.PropTypes.object.isRequired

  contextTypes:
    user: React.PropTypes.object

  render: ->
    profileData = @props.profile or @context.user
    if profileData
      profile = UserBrief user: profileData
    else
      profile = div {}

    entries = for key, entries of @props.history
      try
        title = @getIntlMessage key
      catch error
        title = key

      div key: key, className: 'section',
        div className: 'section-title', title
        entries.map (e) ->
          a className: 'history-entry', href: '/histories',
            div className: 'title', e.title
            div className: 'description', e.description

    div id: @props.id, className: 'comp-historybrief',
      profile
      div className: 'activity',
        @getIntlMessage 'recent-activity'
      entries
      a className: 'view-more histories-view-more', href: '/histories',
        @getIntlMessage('view-more')
