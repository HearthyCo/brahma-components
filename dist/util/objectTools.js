var exports;

exports = {
  indexArrSet: function(obj, arr, value) {
    if (arr.length === 1) {
      return obj[arr[0]] = value;
    } else if (arr.length > 1) {
      if (obj[arr[0]] === void 0) {
        obj[arr[0]] = {};
      }
      return exports.indexArrSet(obj[arr[0]], arr.slice(1), value);
    }
  },
  indexStrSet: function(obj, str, value) {
    return exports.indexArrSet(obj, str.split('.'), value);
  }
};

module.exports = exports;
