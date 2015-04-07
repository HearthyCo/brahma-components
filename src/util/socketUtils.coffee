
counter = 0

module.exports =
  # Creates a new Entity Store for the given entity name
  mkMessageId: (user, session) ->
    date = new Date().getTime()
    session = session or 0
    '' + user + '.' + session + '.' + date + '.' + counter++