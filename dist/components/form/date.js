var React, div, label, option, select, _ref;

React = require('react');

select = React.createFactory(require('./select'));

_ref = React.DOM, div = _ref.div, label = _ref.label, option = _ref.option;

module.exports = React.createClass({
  days: function() {
    var days, i, _i;
    days = [];
    days.push(option({
      key: 0,
      value: 0
    }, 'Día'));
    for (i = _i = 1; _i <= 31; i = ++_i) {
      days.push(option({
        key: i,
        value: i
      }, {
        i: i
      }));
    }
    return days;
  },
  months: function() {
    var i, months, names, _i, _ref1;
    months = [];
    names = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
    months.push(option({
      key: 0,
      value: 0
    }, 'Mes'));
    for (i = _i = 1, _ref1 = names.length; 1 <= _ref1 ? _i <= _ref1 : _i >= _ref1; i = 1 <= _ref1 ? ++_i : --_i) {
      months.push(option({
        key: i,
        value: i
      }, names[i - 1]));
    }
    return months;
  },
  years: function() {
    var date, i, year, years, _i;
    years = [];
    date = new Date();
    year = date.getFullYear();
    years.push(option({
      key: 0,
      value: 0
    }, 'Año'));
    for (i = _i = 1900; 1900 <= year ? _i <= year : _i >= year; i = 1900 <= year ? ++_i : --_i) {
      years.push(option({
        key: i,
        value: i
      }, {
        i: i
      }));
    }
    return years;
  },
  render: function() {
    return div({
      id: this.props.id,
      className: 'field-set'
    }, div({
      className: 'label'
    }, label({
      className: 'label-form'
    }, this.props.label)), div({
      className: 'field'
    }, select({
      name: 'day',
      options: this.days()
    }), select({
      name: 'month',
      options: this.months()
    }), select({
      name: 'year',
      options: this.years()
    })), div({
      className: 'message'
    }, label({
      className: 'message-form'
    })));
  }
});
