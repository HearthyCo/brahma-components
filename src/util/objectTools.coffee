exports = {

  indexArrSet: (obj, arr, value) ->
    if arr.length is 1
      obj[arr[0]] = value
    else if arr.length > 1
      if obj[arr[0]] is undefined
        obj[arr[0]] = {}
      exports.indexArrSet obj[arr[0]], arr.slice(1), value

  indexStrSet: (obj, str, value) ->
    exports.indexArrSet obj, str.split('.'), value

}

module.exports = exports