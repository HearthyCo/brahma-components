React = require 'react'
moment = require 'moment'
ReactIntl = require 'react-intl'
_ = require 'underscore'

{ div, img, span, a, i } = React.DOM

module.exports = React.createClass

  displayName: 'calendar'

  mixins: [ReactIntl]

  getDefaultProps: ->
    selected: moment()
    date: moment()
    month: moment()
    week: moment()

  getInitialState: ->
    month: @props.selected.clone()

  previous: ->
    month = @state.month
    month.add -1, 'M'
    @setState month: month

  next: ->
    month = @state.month
    month.add 1, 'M'
    @setState month: month

  select: ->
    @props.selected = day.date
    @forceUpdate()

  renderMonthLabel: ->
    span @state.month.format 'MMMM, YYYY'

  render: ->

    DayNames =
      div className: 'week names',
        span className: 'day', 'Dom'
        span className: 'day', 'Lun'
        span className: 'day', 'Mar'
        span className: 'day', 'Mie'
        span className: 'day', 'Jue'
        span className: 'day', 'Vie'
        span className: 'day', 'Sab'

    weeks = []
    done = false
    date = @state.month.clone().startOf('month').add('w', -1).day 'Sunday'
    monthIndex = date.month()
    count = 0

    while !done

      days = []
      date2 = date.clone()
      month = @props.month

      i = 0
      while i < 7
        day =
          name: date2.format('dd').substring(0, 1)
          number: date2.date()
          isCurrentMonth: date2.month() == month.month()
          isToday: date2.isSame(new Date, 'day')
          date: date2
        i++

        days.push(
          span
            key: day.date.toString()
            className: 'day' + (if day.isToday then ' today' else '') + (if day.isCurrentMonth then '' else ' different-month') + (if day.date.isSame(@props.selected) then ' selected' else ''), day.number
        )
        date2.add(1, 'd')

      weeks.push div className: 'week', key: date.day(), days
      #Week key: date.toString(), date: date.clone(), month: @state.month, select: @select, selected: @props.selected
      date.add 1, 'w'
      done = count++ > 2 and monthIndex != date.month()
      monthIndex = date.month()



    div className: 'comp-calendar',
      div className: 'header',
        div className: 'fa icon icon-left', onClick: @previous
        @renderMonthLabel()
        div className: 'fa icon icon-right', onClick: @next

      DayNames
      weeks
