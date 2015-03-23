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

  imageScaleBlob: (file, maxWidth, maxHeight, callback) ->
    url = URL.createObjectURL file
    img = document.createElement 'img'
    img.onload = =>
      # Check if file is of a correct size already
      if img.width <= maxWidth and img.height <= maxHeight
        return callback file

      ratio = Math.min maxWidth / img.width, maxHeight / img.height
      canvas = document.createElement 'canvas'
      canvas.width = img.width * ratio
      canvas.height = img.height * ratio
      ctx = canvas.getContext '2d'
      ctx.drawImage img, 0, 0, canvas.width, canvas.height
      URL.revokeObjectURL url
      targetType = file.type
      if targetType isnt 'image/jpeg' and targetType isnt 'image/png'
        targetType = 'image/jpeg'
      if canvas.toBlob
        canvas.toBlob callback, targetType, 0.9
      else
        dataurl = canvas.toDataURL file.type, 0.9
        dataurl = dataurl.substring dataurl.indexOf(',') + 1
        callback @b64toBlob dataurl, targetType

    img.onerror = ->
      console.error 'Image can\'t be loaded by the client.'
      callback file

    img.src = url
