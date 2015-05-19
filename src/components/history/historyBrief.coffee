React = require 'react'
_ = require 'underscore'
ReactIntl = require '../../mixins/ReactIntl'

{ a, img, span, div } = React.DOM

HomeUserbrief = React.createFactory require '../user/homeUserbrief'

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
      profile = HomeUserbrief user: profileData
    else
      profile = div {}

    history = _.omit @props.history, "treatments", "conditions"
    entries = for key, list of history
      try
        title = @getIntlMessage key
      catch error
        title = key

      div key: key, className: 'section',
        div className: 'section-title', title
        list.map (e, i) ->
          span className: 'history-entry', key: i,
            div className: 'title', e
            #div className: 'description', e.description

    div id: @props.id, className: 'comp-historybrief',
      profile
      a className: 'view-more histories-view-more', href: '/profile',
        @getIntlMessage 'edit'
      if entries.length
        div className: 'activity',
          @getIntlMessage 'recent-activity'
      entries
        # a className: 'view-more histories-view-more', href: '/histories',
        #   @getIntlMessage 'view-more'
