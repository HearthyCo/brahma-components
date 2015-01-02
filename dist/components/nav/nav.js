var React, nav;

React = require('react');

nav = React.DOM.nav;

module.exports = React.createClass({
  propTypes: {
    active: React.PropTypes.string,
    onSelect: React.PropTypes.func
  },
  render: function() {
    return this.transferPropsTo(nav({}, React.Children.map(this.props.children, this.renderChild)));
  },
  renderChild: function(child, i) {
    return React.addons.cloneWithProps(child, {
      active: this.props.active === i,
      key: i,
      onSelect: this.props.onSelect.bind(null, i)
    });
  }
});
