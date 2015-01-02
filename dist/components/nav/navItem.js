var React;

React = require('react');

module.exports = React.createClass({
  propTypes: {
    active: React.PropTypes.bool,
    onSelect: React.PropTypes.func
  },
  render: function() {
    var _ref;
    return this.transferPropsTo(a({
      className: (_ref = this.props.active) != null ? _ref : {
        'active': '',
        onClick: this.props.onSelect
      }
    }, [this.props.label]));
  }
});
