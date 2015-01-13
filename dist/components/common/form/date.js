var React, div, label, option, select, _, _ref;

React = require('react');

_ = require('underscore');

_ref = React.DOM, div = _ref.div, label = _ref.label, option = _ref.option, select = _ref.select;

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
  valueAsObj: function() {
    var obj, originalDate;
    originalDate = this.props.valueLink ? this.props.valueLink.value : void 0;
    originalDate = originalDate || '0000-00-00';
    return obj = {
      year: parseInt(originalDate.substr(0, 4)),
      month: parseInt(originalDate.substr(5, 2)),
      day: parseInt(originalDate.substr(8, 2))
    };
  },
  handleChange: function(key, e) {
    var date, obj, val;
    val = e.target.value;
    obj = this.valueAsObj();
    obj[key] = val;
    date = ("0000" + obj.year).substr(-4) + '-';
    date += ("00" + obj.month).substr(-2) + '-';
    date += ("00" + obj.day).substr(-2);
    if (this.props.valueLink) {
      return this.props.valueLink.requestChange(date);
    }
  },
  mkSelect: function(name, options, value) {
    return select({
      className: 'select-form',
      name: name,
      value: value,
      onChange: this.handleChange.bind(this, name)
    }, options);
  },
  render: function() {
    var obj;
    obj = this.valueAsObj();
    return div({
      id: this.props.id,
      className: 'field-set field-date'
    }, div({
      className: 'label'
    }, label({
      className: 'label-form'
    }, this.props.label)), div({
      className: 'field'
    }, this.mkSelect('day', this.days(), obj.day), this.mkSelect('month', this.months(), obj.month), this.mkSelect('year', this.years(), obj.year)), div({
      className: 'message'
    }, label({
      className: 'message-form'
    })));
  }
});
