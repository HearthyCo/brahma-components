React = require("react")
{ div, label, select } = React.DOM

module.exports = React.createClass
  render: ->
    div(
      className: "field-set"
      , div(
        className: "field"
        , select(
          className: "select-form"
          name: @props.name
          , @props.options
        )
      )
    )