
{nav} = React.DOM

module.exports = React.createClass
  propTypes:
    active: React.PropTypes.string
    onSelect: React.PropTypes.func

  render: ->
    # use React.Children.map because children is opaque
    return @transferPropsTo (nav {}, [
        React.Children.map @props.children, @renderChild
      ])

  renderChild: (child, i) ->
    return React.addons.cloneWithProps child, {
      # use the prop, not state
      active: @props.active == i
      key: i

      # let the parent decide how to handle the data change
      # give it the clicked index
      onSelect: @props.onSelect.bind(null, i)
    }