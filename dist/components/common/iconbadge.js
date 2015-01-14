var React, div, img, span, _ref;

React = require('react');

_ref = React.DOM, div = _ref.div, img = _ref.img, span = _ref.span;

module.exports = React.createClass({
  propTypes: {
    id: React.PropTypes.string,
    value: React.PropTypes.number,
    icon: React.PropTypes.string.isRequired
  },
  getDefaultProps: function() {
    return {
      value: 0
    };
  },
  render: function() {
    return div({
      id: this.props.id,
      className: 'comp-iconbadge'
    }, this.props.value ? span({
      className: 'badge'
    }, this.props.value) : void 0, img({
      className: 'icon',
      src: this.props.icon
    }));
  }
});
