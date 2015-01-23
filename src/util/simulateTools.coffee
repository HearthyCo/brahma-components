module.exports =

  linkClick: (url) ->
    a = document.createElement 'a'
    a.style.display = 'none'
    document.body.appendChild a
    a.href = url
    evt = document.createEvent 'HTMLEvents'
    evt.initEvent 'click', true, true
    a.dispatchEvent evt
    document.body.removeChild a