_ = require 'underscore'

module.exports =

  pickFile: (callback) ->
    filewrapper = document.createElement 'div'
    filewrapper.innerHTML = '<input type="file">'
    file = filewrapper.firstChild
    file.addEventListener 'change', callback, false
    file.click()

  humanFilesize: (bytes) ->
    units = ['B','KiB','MiB','GiB','TiB']
    u = 0
    while bytes >= 1024
      bytes /= 1024
      u++
    bytes.toFixed(1) + ' ' + units[u]
