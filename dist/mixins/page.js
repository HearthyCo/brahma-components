var React, div;

React = require('react');

div = React.DOM.div;

module.exports = React.createClass({
  render: function() {
    return div({
      id: 'content'
    });
  }
});
