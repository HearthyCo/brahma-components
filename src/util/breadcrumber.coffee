exports = {

  urlBuilder: (args...) ->
    url = "/" unless args
    url += "/" + arg for arg in args
    url

  crumbBuilder: (label, link, cls) ->
    { label: label, link: link, class: cls }

  breadcrumBuilder: (list) ->
    list.unshift @crumbBuilder 'Home', @urlBuilder(), 'crumb icon icon-home'
    { list: list }

  sessions: (key) -> (args) ->
    sessions = []
    sessions.push @crumbBuilder 'Consultas',
      @urlBuilder('sessions'), 'crumb icon icon-clock'

    if key?
      sessions.push @crumbBuilder args[key],
        @urlBuilder('sessions', args[key]), 'crumb icon icon-clock'

    console.log "SESSIONS ", JSON.stringify sessions

    @breadcrumBuilder sessions
}

module.exports = exports