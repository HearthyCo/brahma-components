_ = require 'underscore'

# Adapted from https://gist.github.com/louisremi/1114293#file_anim_loop_x.js
raf = window.requestAnimationFrame       or
      window.mozRequestAnimationFrame    or
      window.webkitRequestAnimationFrame or
      window.msRequestAnimationFrame     or
      window.oRequestAnimationFrame;
animLoop = (render, element) ->
  ###coffeelint-variable-scope-ignore###
  running = true
  ###coffeelint-variable-scope-ignore###
  lastFrame = +new Date
  theloop = (now) ->
    if running != false
      if raf
        raf theloop, element
      else
        window.setTimeout theloop, 16
      now = if now? > 1e4 then now else +new Date
      deltaT = now - lastFrame
      if deltaT < 160
        running = render deltaT, now
      lastFrame = now;
  theloop()


window.brahma.utils.frontend = module.exports =

  # Shows the "Select file" dialog, and passes the selection to the callback.
  pickFile: (callback) ->
    filewrapper = window.document.createElement 'div'
    filewrapper.innerHTML = '<input type="file">'
    file = filewrapper.firstChild
    window.document.body.appendChild file
    cbwrapper = ->
      callback.apply @, arguments
      window.document.body.removeChild file
    file.addEventListener 'change', cbwrapper, false
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
    contentType = contentType or ''
    sliceSize = sliceSize or 512

    byteCharacters = window.atob b64Data
    byteArrays = []

    offset = 0
    while offset < byteCharacters.length
      slice = byteCharacters.slice offset, offset + sliceSize

      byteNumbers = new Array slice.length
      i = 0
      while i < slice.length
        byteNumbers[i] = slice.charCodeAt(i)
        i++

      byteArray = new window.Uint8Array byteNumbers
      byteArrays.push byteArray

      offset += sliceSize

    blob = new window.Blob byteArrays, type: contentType
    blob

  # Resizes a file using the given resizer function, and passes the
  # result blob to the callback.
  imageResizeBlob: (file, callback, resizer) ->
    url = window.URL.createObjectURL file
    img = window.document.createElement 'img'
    img.onload = =>
      canvas = window.document.createElement 'canvas'
      ret = resizer img, canvas
      if not ret
        return callback file
      window.URL.revokeObjectURL url
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

  # Animates a scroll to the specified element, taking into account that it
  # might have an ongoing animation. Useful for accordions.
  # offset: Margin to leave between the top of the element and the viewport
  scrollAnimated: (element, offset) ->
    # Scroll animation length. Should be >= to the element's animation length.
    length = 500 # ms
    # Animation easing function. Should take and output values in range 0..1.
    easing = (x) -> x * x * (3 - 2 * x)

    # Calculate the fixed points of our animations
    offset = offset or 0
    startScroll = window.pageYOffset
    endScroll = 0
    t = element
    while t
      endScroll += t.offsetTop
      t = t.offsetParent
    endScroll -= offset
    perMsScroll = (endScroll - startScroll) / length

    ###coffeelint-variable-scope-ignore###
    totalT = 0

    # Set our animation loop
    animLoop (deltaT) ->
      totalT += deltaT
      window.scroll 0, startScroll + totalT * perMsScroll
      return totalT < length

  # Returns the full name of a user
  fullName: (user) ->
    ['name', 'surname1', 'surname2']
      .map (f) -> user[f]
      .filter (v) -> v
      .join ' '