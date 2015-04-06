React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'

{ div, p, textarea, button } = React.DOM

SublistEntry = React.createFactory require './sublistEntry'

SessionActions = require '../../actions/SessionActions'
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
    props = props || @props
    newValue = oldValue = ReportStore.get props.session?.id
    if props.session and props.sessionUser
      if not oldValue and props.sessionUser.report?.length
        newValue = props.sessionUser.report
        ReportStore.set props.session.id, newValue

    state =
      report: newValue

    @setState state if @isMounted()
    state

  handleReportSave: ->
    SessionActions.updateReport @props.sessionUser.id,
      ReportStore.get @props.session?.id

  handleFinish: ->
    if true
      SessionActions.finish @props.session.id

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

    # TODO: @getIntlMessage 'everything...'
    div className: 'comp-reportEditor',
      '< ' + fullname
      p {}, header

      SublistEntry label: 'Crear informe', defaultOpen: true,
        'Escribe un informe'
        textarea valueLink: ReportStore.linkState @props.session?.id
        button onClick: @handleReportSave, 'Guardar'

      SublistEntry label: 'Crear tratamiento',
        div {}, 'Recomendaciones'
        div {}, 'Fármacos'

      div className: 'end-session',
        button onClick: @handleFinish,
          @getIntlMessage 'finish'