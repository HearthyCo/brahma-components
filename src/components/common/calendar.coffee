React = require 'react'
moment = require 'moment'
ReactIntl = require '../../mixins/ReactIntl'
_ = require 'underscore'

{ div, span } = React.DOM

module.exports = React.createClass

  displayName: 'calendar'

  mixins: [ReactIntl]

  getDefaultProps: ->
    selected: moment()

  getInitialState: ->
    month: @props.selected.clone()
    selected: @props.selected.clone()

  previous: ->
    month = @state.month
    month.add -1, 'M'
    @setState month: month

  next: ->
    month = @state.month
    month.add 1, 'M'
    @setState month: month

  select: (date) ->
    @setState selected: date

  render: ->

    DayNames =
      div className: 'week names',
        span className: 'day', @getIntlMessage 'mon'
        span className: 'day', @getIntlMessage 'tue'
        span className: 'day', @getIntlMessage 'wed'
        span className: 'day', @getIntlMessage 'thu'
        span className: 'day', @getIntlMessage 'fri'
        span className: 'day', @getIntlMessage 'sat'
        span className: 'day', @getIntlMessage 'sun'

    weeks = []
    done = false
    date = @state.month.clone().startOf('month').startOf('isoWeek')
    monthIndex = date.month()
    count = 0
    month = @state.month
    _this = @

    while !done

      days = []
      date2 = date.clone()

      i = 0
      while i < 7
        day =
          name: date2.format('dd').substring(0, 1)
          number: date2.date()
          isCurrentMonth: date2.month() is month.month()
          isToday: date2.isSame(new Date, 'day')
          date: date2.clone()
        i++

        classname = 'day'
        classname += ' today' if day.isToday
        classname += ' different-month' if not day.isCurrentMonth
        classname += ' selected' if day.date.isSame(@state.selected)
        days.push span
          key: day.date.toString()
          onClick: ((day) -> -> _this.select day.date) day
          date: day.date
          className: classname,
          span className: 'colored', day.number
        date2.add(1, 'd')

      weeks.push div className: 'week', key: date.unix(), days
      date.add 1, 'w'
      done = count++ > 2 and monthIndex != date.month()
      monthIndex = date.month()



    div className: 'comp-calendar',
      div className: 'header',
        span className: 'icon icon-left', onClick: @previous
        span className: 'month', @state.month.format 'MMMM, YYYY'
        span className: 'icon icon-right', onClick: @next

      DayNames
      weeks
