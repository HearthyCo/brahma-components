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

  b64toBlob: (b64Data, contentType, sliceSize) ->
    contentType = contentType || ''
    sliceSize = sliceSize || 512

    byteCharacters = atob b64Data
    byteArrays = []

    offset = 0
    while offset < byteCharacters.length
      slice = byteCharacters.slice offset, offset + sliceSize

      byteNumbers = new Array slice.length
      i = 0
      while i < slice.length
        byteNumbers[i] = slice.charCodeAt(i)
        i++

      byteArray = new Uint8Array byteNumbers
      byteArrays.push byteArray

      offset += sliceSize

    blob = new Blob byteArrays, type: contentType
    blob
