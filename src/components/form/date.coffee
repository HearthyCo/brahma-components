React = require 'react'
_ = require 'underscore'

select = React.createFactory require './select'
{ div, label, option } = React.DOM

module.exports = React.createClass(
  days: ->
    days = []
    days.push option { key: 0, value: 0 }, 'Día'
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

    months.push option {key: 0, value: 0}, 'Mes'
    months.push option {key: i, value: i}, names[i-1] for i in [1..names.length]
    months

  years: ->
    years = []
    date = new Date()
    year = date.getFullYear()

    years.push option { key: 0, value: 0 }, 'Año'
    years.push option { key: i, value: i }, {i} for i in [1900..year]
    years

  valueAsObj: ->
    originalDate = @props.value || '0000-00-00'
    obj =
      year: parseInt originalDate.substr(0, 4)
      month: parseInt originalDate.substr(5, 2)
      day: parseInt originalDate.substr(8, 2)

  handleChange: (key, val) ->
    obj = @valueAsObj()
    obj[key] = val
    date = ("0000" + obj.year).substr(-4) + '-'
    date += ("00" + obj.month).substr(-2) + '-'
    date += ("00" + obj.day).substr(-2)
    @props.callback @props.name, date

  render: ->
    obj = @valueAsObj()
    div(
      id: @props.id
      className: 'field-set'
      , div(
        className: 'label'
        , label(
          className: 'label-form'
          , @props.label
        )
      )
      , div(
        className: 'field'
        , select(
          name: 'day'
          options: @days()
          value: obj.day
          callback: @handleChange
        )

        , select(
          name: 'month'
          options: @months()
          value: obj.month
          callback: @handleChange
        )

        , select(
          name: 'year'
          options: @years()
          value: obj.year
          callback: @handleChange
        )
      )
      , div(
        className: 'message'
        , label(
          className: 'message-form'
        )
      )
    ))