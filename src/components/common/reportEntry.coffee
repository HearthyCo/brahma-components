React = require 'react'
ReactIntl = require '../../mixins/ReactIntl'

{ div, textarea, button } = React.DOM

SessionActions = require '../../actions/SessionActions'

StateStores = require('../../stores/StateStores')
ReportStore = StateStores.chatTabs.reports


module.exports = React.createClass

  displayName: 'reportEntry'

  mixins: [ReactIntl]

  propTypes:
    session: React.PropTypes.object.isRequired
    sessionUser: React.PropTypes.object.isRequired

  getInitialState: ->
    @updateReport()

  componentDidMount: ->
    ReportStore.addChangeListener @updateReport

  componentWillUnmount: ->
    ReportStore.removeChangeListener @updateReport

  componentWillReceiveProps: (next) ->
    if @props.session?.id isnt next.session?.id
      @updateReport next

  updateReport: (props) ->
    # We have to juggle with old and new values to use '' instead of null
    # Blame at: https://github.com/facebook/react/issues/2533
    props = props or @props
    newValue = ReportStore.get props.session?.id
    if props.session and props.sessionUser and props.sessionUser.report?.length
      oldValue = props.sessionUser.report
      if not newValue
        newValue = oldValue
        ReportStore.set props.session.id, oldValue

    reportStatus = if newValue is oldValue then 'saved' else 'edited'

    state =
      report: newValue
      reportStatus: reportStatus

    @setState state if @isMounted()
    state

  handleReportSave: ->
    r = SessionActions.updateReport @props.sessionUser.id,
      ReportStore.get @props.session?.id
    @setState reportStatus: 'saving'
    r.then(
      => @setState reportStatus: 'saved'
      => @setState reportStatus: 'error'
    )

  render: ->
    saveReportDisabled = @state.reportStatus in ['saved', 'saving']

    div className: 'comp-reportEntry',
      div className: 'label',
        @getIntlMessage 'write-report'
      textarea
        valueLink: ReportStore.linkState @props.session?.id
        required: true
      button
        onClick: @handleReportSave
        className: @state.reportStatus
        disabled: saveReportDisabled,
        @getIntlMessage 'save'
