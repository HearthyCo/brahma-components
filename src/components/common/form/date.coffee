React = require 'react'
ReactIntl = require '../../../mixins/ReactIntl'
_ = require 'underscore'

{ div, label, option, select } = React.DOM

module.exports = React.createClass

  displayName: 'date'

  mixins: [ReactIntl]

  days: ->
    days = []
    days.push option { key: 0, value: '' }, @getIntlMessage('day')
    days.push option { key: i, value: i }, {i} for i in [1..31]
    days

  months: ->
    months = []
    names = [
      'Enero'
      'Febrero'
      'Marzo'
      'Abril'
      'Mayo'
      'Junio'
      'Julio'
      'Agosto'
      'Septiembre'
      'Octubre'
      'Noviembre'
      'Diciembre'
    ]

    months.push option {key: 0, value: ''}, @getIntlMessage('month')
    months.push option {key: i, value: i}, names[i-1] for i in [1..names.length]
    months

  years: ->
    years = []
    date = new Date()
    year = date.getFullYear()

    years.push option { key: 0, value: '' }, @getIntlMessage('year')
    years.push option { key: i, value: i }, {i} for i in [1900..year]
    years

  valueAsObj: ->
    originalDate = if @props.valueLink then @props.valueLink.value
    originalDate = originalDate or '0000-00-00'
    obj =
      year: parseInt originalDate.substr(0, 4)
      month: parseInt originalDate.substr(5, 2)
      day: parseInt originalDate.substr(8, 2)

  handleChange: (key, e) ->
    val = e.target.value
    obj = @valueAsObj()
    obj[key] = val
    date = ("0000" + obj.year).substr(-4) + '-'
    date += ("00" + obj.month).substr(-2) + '-'
    date += ("00" + obj.day).substr(-2)
    if @props.valueLink
      @props.valueLink.requestChange date

  mkSelect: (opts, options) ->
    opts.className = 'select-form'
    opts.onChange = @handleChange.bind(@, opts.name)

    select opts,
      options

  render: ->
    obj = @valueAsObj()

    day =
      name: 'day'
      value: obj.day

    month =
      name: 'month'
      value: obj.month

    year =
      name: 'year'
      value: obj.year

    if @props.required
      day.required = true
      month.required = true
      year.required = true

    div id: @props.id, className: 'field-set comp-date',
      div className: 'label',
        label className: 'label-form',
          @props.label
      div className: 'field',
        @mkSelect day, @days()
        @mkSelect month, @months()
        @mkSelect year, @years()
      div className: 'message',
        label className: 'message-form'