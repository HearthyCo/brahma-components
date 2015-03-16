React = require 'react'

{ table, tbody, thead, tr, td, th, a } = React.DOM

crudControls = (id) ->
  [
    a href: "", "edit"
    a href: "", "delete"
  ]

module.exports = React.createClass

  displayName: 'crudTable'

  propTypes:
    id: React.PropTypes.string
    items: React.PropTypes.array

  render: ->
    keys = @props.header or Object.keys @props.items[0]

    table id: @props.id,
      thead {},
        tr
          keys.map (key) ->
            th className: "key-#{key}", key
          th className: "controls", "controls"
      tbody {},
        @props.items.map (item, i) ->
          tr id: item.id,
            keys.map (key) ->
              td className: "key-#{key}", item[key]
            td className: "controls",
              crudControls item.id
