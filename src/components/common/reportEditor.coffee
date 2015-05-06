React = require 'react/addons'
ReactIntl = require '../../mixins/ReactIntl'
_ = require 'underscore'

{ div, p, button, span } = React.DOM

IconSubListEntry = React.createFactory require './iconSublistEntry'
ReportEntry = React.createFactory require './reportEntry'
ReportTaskEntry = React.createFactory require './reportTaskEntry'

SessionActions = require '../../actions/SessionActions'
PageActions = require '../../actions/PageActions'
EntityStores = require '../../stores/EntityStores'
ListStores = require '../../stores/ListStores'
StateStores = require('../../stores/StateStores')
OpenSectionsStore = StateStores.chatTabs.openSections


module.exports = React.createClass

  displayName: 'reportEditor'

  mixins: [ReactIntl]

  propTypes:
    session: React.PropTypes.object.isRequired
    sessionUser: React.PropTypes.object.isRequired
    user: React.PropTypes.object.isRequired

  handleFinish: ->
    r = SessionActions.finish @props.session.id
    r.then(
      -> PageActions.navigate '/'
      -> # Nothing
    )

  handleHide: ->
    OpenSectionsStore.set @props.session.id, null

  render: ->
    if @props.user
      fullname = ['name', 'surname1', 'surname2']
        .map (f) => @props.user[f]
        .filter (v) -> v
        .join ' '
    else
      fullname = @getIntlMessage 'loading'

    if @props.session.state is 'CLOSED'
      header = @getIntlMessage 'session-is-over'
    else
      header = @getIntlMessage 'create-report-during-session'

    reportLabel = @getIntlMessage 'create-report'
    # taskLabel = @getIntlMessage 'create-treatment'


    div className: 'comp-reportEditor',
      div className: 'content',
        div className: 'session-title',
          div className: 'session-client',
            span className: 'icon icon-arrow-left', onClick: @handleHide
            span className: 'name', fullname
            p className: 'intro', header

        IconSubListEntry icon: 'pencil', label: reportLabel, defaultOpen: true,
          ReportEntry session: @props.session, sessionUser: @props.sessionUser

        # IconSubListEntry label: taskLabel, icon: 'pill',
        #   ReportTaskEntry {}

        div className: 'end-session',
          if @props.session.state is 'CLOSED'
            button
              onClick: @handleFinish,
              @getIntlMessage 'finish-session'
