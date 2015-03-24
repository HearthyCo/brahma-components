_ = require 'underscore'

module.exports =

  # Shows the "Select file" dialog, and passes the selection to the callback.
  pickFile: (callback) ->
    filewrapper = document.createElement 'div'
    filewrapper.innerHTML = '<input type="file">'
    file = filewrapper.firstChild
    file.addEventListener 'change', callback, false
    file.click()

  # Converst a number of bytes into a human-readable string
  humanFilesize: (bytes) ->
    units = ['B','KiB','MiB','GiB','TiB']
    u = 0
    while bytes >= 1024
      bytes /= 1024
      u++
    bytes.toFixed(1) + ' ' + units[u]

  # Converts a base64 string into a blob, optionally setting its content type.
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

  # Resizes a file using the given resizer function, and passes the
  # result blob to the callback.
  imageResizeBlob: (file, callback, resizer) ->
    url = URL.createObjectURL file
    img = document.createElement 'img'
    img.onload = =>
      canvas = document.createElement 'canvas'
      ret = resizer img, canvas
      if not ret
        return callback file
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

  # Scales a image so it is contained on the given box.
  imageScaleBlob: (file, maxWidth, maxHeight, callback) ->
    @imageResizeBlob file, callback, (img, canvas) ->
      if img.width <= maxWidth and img.height <= maxHeight
        return false

      ratio = Math.min maxWidth / img.width, maxHeight / img.height
      canvas.width = img.width * ratio
      canvas.height = img.height * ratio
      ctx = canvas.getContext '2d'
      ctx.drawImage img, 0, 0, canvas.width, canvas.height
      true

  # Scales and crops a image so it covers the given box.
  imageScaleCropBlob: (file, width, height, callback) ->
    @imageResizeBlob file, callback, (img, canvas) ->
      ratio = width / height
      sratio = img.width / img.height
      sw = img.width
      sh = img.height
      sx = sy = 0
      if sratio > ratio
        sw = img.height * ratio
        sx = (img.width - sw) / 2
      else
        sh = img.width / ratio
        sy = (img.height - sh) / 2
      canvas.width = width
      canvas.height = height
      ctx = canvas.getContext '2d'
      console.log 'ctx.drawImage img', sx, sy, sw, sh, 0, 0, width, height
      ctx.drawImage img, sx, sy, sw, sw, 0, 0, width, height
      true