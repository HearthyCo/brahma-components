React = require 'react/addons'
ReactIntl = require '../../mixins/ReactIntl'
_ = require 'underscore'

{ div, p, textarea, button, span } = React.DOM

IconSubListEntry = React.createFactory require './iconSublistEntry'
# ReportEntry = React.createFactory require './reportentry'

SessionActions = require '../../actions/SessionActions'
PageActions = require '../../actions/PageActions'
EntityStores = require '../../stores/EntityStores'
ListStores = require '../../stores/ListStores'

StateStores = require('../../stores/StateStores')
ReportStore = StateStores.chatTabs.reports
OpenSectionsStore = StateStores.chatTabs.openSections

module.exports = React.createClass

  displayName: 'reportEditor'

  mixins: [ReactIntl]

  propTypes:
    session: React.PropTypes.object.isRequired
    sessionUser: React.PropTypes.object.isRequired
    user: React.PropTypes.object.isRequired

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
      header = 'La consulta ha finalizado. Por favor escribe ...'
    else
      header = 'Puedes ir cubriendo el informe durante la sesión.'

    saveReportDisabled = @state.reportStatus in ['saved', 'saving']

    # TODO: @getIntlMessage 'everything...'
    div className: 'comp-reportEditor',
      div className: 'content',
        div className: 'session-title',
          div className: 'session-client',
            span className: 'icon icon-arrow-left', onClick: @handleHide
            span className: 'name', fullname
            p className: 'intro', header

        IconSubListEntry icon: 'pencil', label: 'Crear informe', defaultOpen: true,
          div className: 'comp-reportEntry',
            div className: 'label',
              'Escribe un informe'
            textarea valueLink: ReportStore.linkState @props.session?.id
            button
              onClick: @handleReportSave
              className: @state.reportStatus
              disabled: saveReportDisabled,
              'Guardar'

        IconSubListEntry label: 'Crear tratamiento', icon: 'pill',
          div className: 'comp-treatmentEntry',
            div className: 'treatment-type', 'Recomendaciones'
            div className: 'treatment-type', 'Fármacos'

      div className: 'end-session',
        button onClick: @handleFinish,
          @getIntlMessage 'finish'
