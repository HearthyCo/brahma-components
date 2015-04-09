React = require 'react/addons'
ReactIntl = require '../../mixins/ReactIntl'
_ = require 'underscore'

{ div, p, textarea, button } = React.DOM

SublistEntry = React.createFactory require './sublistEntry'

SessionActions = require '../../actions/SessionActions'
PageActions = require '../../actions/PageActions'
EntityStores = require '../../stores/EntityStores'
ListStores = require '../../stores/ListStores'

ReportStore = require('../../stores/StateStores').chatTabs.reports

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
      '< ' + fullname
      p {}, header

      SublistEntry label: 'Crear informe', defaultOpen: true,
        'Escribe un informe'
        textarea valueLink: ReportStore.linkState @props.session?.id
        button
          onClick: @handleReportSave
          className: @state.reportStatus
          disabled: saveReportDisabled,
          'Guardar'

      SublistEntry label: 'Crear tratamiento',
        div {}, 'Recomendaciones'
        div {}, 'Fármacos'

      div className: 'end-session',
        button onClick: @handleFinish,
          @getIntlMessage 'finish'