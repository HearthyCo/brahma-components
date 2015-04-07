module.exports = exports =

  indexArrSet: (obj, arr, value) ->
    if arr.length is 1
      obj[arr[0]] = value
    else if arr.length > 1
      if obj[arr[0]] is undefined
        obj[arr[0]] = {}
      exports.indexArrSet obj[arr[0]], arr.slice(1), value

  indexStrSet: (obj, str, value) ->
    exports.indexArrSet obj, str.split('.'), value

  flatten: (obj, path, ret) ->
    ret = ret or {}
    path = path or ''
    if typeof(obj) != 'object'
      ret[path] = obj
      return ret
    if path isnt ''
      path += '.'
    for k, v of obj
      @flatten v, path + k, ret
    ret

  unflatten: (obj) ->
    ret = {}
    for k, v of obj
      @indexStrSet ret, k, v
    ret