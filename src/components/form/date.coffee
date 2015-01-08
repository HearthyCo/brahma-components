React = require 'react'
select = React.createFactory require './select'
{ div, label, option } = React.DOM

module.exports = React.createClass(
  days: ->
    days = []
    days.push option { key: 0, value: 0 }, ''
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

    months.push option {key: '', value: 0}, ''
    months.push option {key: i, value: i}, names[i-1] for i in [1..names.length]
    months

  years: ->
    years = []
    date = new Date()
    year = date.getFullYear()

    years.push option { key: '', value: 0 }, ''
    years.push option { key: i, value: i }, {i} for i in [1900..year]
    years

  render: ->
    div(
      className: 'field-set'
      , div(
        className: 'field'
        , label(
          className: 'label-form'
          , @props.label
        )
      )
      , div(
        className: 'field'
        , select(
          name: 'day'
          label: 'Día'
          options: @days()
        )

        , select(
          name: 'month'
          label: 'Mes'
          options: @months()
        )

        , select(
          name: 'year'
          label: 'Año'
          options: @years()
        )
      )
    ))