React = require 'react'

{ table, tbody, thead, tr, td, th, a } = React.DOM

module.exports = React.createClass

  displayName: 'crudTable'

  propTypes:
    type: React.PropTypes.string
    item: React.PropTypes.array

  render: ->
    keys = @props.header or Object.keys @props.items[0]

    db = @props.type

    table id: @props.type,
      thead {},
        tr {},
          keys.map (key) ->
            th className: "key-#{key}", key
      tbody {},
        @props.items.map (item, i) ->
          tr key: item.id, id: "item-#{item.id}",
            keys.map (key) ->
              td key: "key-#{key}", className: "key-#{key}",
                a href: "/crud/#{db}/#{item.id}",
                  item[key]
