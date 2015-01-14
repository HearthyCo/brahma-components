var IconBadge, React, div, img, span, _ref;

React = require('react');

_ref = React.DOM, div = _ref.div, img = _ref.img, span = _ref.span;

IconBadge = React.createFactory(require('./iconbadge'));

module.exports = React.createClass({
  propTypes: {
    id: React.PropTypes.string,
    label: React.PropTypes.string.isRequired,
    icon: React.PropTypes.string.isRequired,
    value: React.PropTypes.number
  },
  getInitialState: function() {
    return {
      isExpanded: false
    };
  },
  toggleDisplay: function() {
    return this.setState({
      isExpanded: !this.state.isExpanded
    });
  },
  render: function() {
    var contentClasses;
    contentClasses = 'entry-content';
    if (this.state.isExpanded) {
      contentClasses += ' is-expanded';
    }
    return div({
      id: this.props.id,
      className: 'comp-mainlistentry'
    }, div({
      className: 'entry-button',
      onClick: this.toggleDisplay
    }, span({
      className: 'label'
    }, this.props.label), IconBadge({
      icon: this.props.icon,
      value: this.props.value
    })), div({
      className: contentClasses
    }, this.props.children));
  }
});
