React = require 'react'

{ table, tbody, tr, td } = React.DOM

module.exports = React.createClass

  displayName: 'crudTable'

  propTypes:
    id: React.PropTypes.string
    items: React.PropTypes.array

  render: ->
    table id: @props.id,
      tbody {},
        @props.items.map (item, i) ->
          tableItem
          tr id: item.id,
            (() ->
              ret = []
              for own key, value of item
                ret.push td className: "key-#{key}", value
              return ret
            )()
