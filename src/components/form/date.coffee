React = require 'react'
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

  render: ->
    div(
      id: @props.id
      className: 'field-set'
      onChange: @handleChange
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
          name: @props.name + '.day'
          options: @days()
          value: @props.value
          callback: @props.callback
        )

        , select(
          name: @props.name + '.month'
          options: @months()
          value: @props.value
          callback: @props.callback
        )

        , select(
          name: @props.name + '.year'
          options: @years()
          value: @props.value
          callback: @props.callback
        )
      )
      , div(
        className: 'message'
        , label(
          className: 'message-form'
        )
      )
    ))