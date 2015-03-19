React = require 'react'

{ table, tbody, thead, tr, td, th, a } = React.DOM

module.exports = React.createClass

  displayName: 'crudTable'

  propTypes:
    type: React.PropTypes.string
    items: React.PropTypes.array

  render: ->
    items = @props.items or []

    console.log 'items', items

    keys = @props.header or

    if @props.header
      keys = @props.header
    else if items.length is 0
      keys = []
    else
      keys = Object.keys items[0]

    db = @props.type

    table id: @props.type,
      thead {},
        tr {},
          keys.map (key) ->
            th className: "key-#{key}", key
      tbody {},
        items.map (item, i) ->
          tr key: item.id, id: "item-#{item.id}",
            keys.map (key) ->
              td key: "key-#{key}", className: "key-#{key}",
                a href: "/crud/#{db}/#{item.id}",
                  item[key]
