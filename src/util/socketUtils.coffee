
module.exports =
  # Creates a new Entity Store for the given entity name
  mkMessageId: (user, counter, session) ->
    date = new Date().getTime()
    session = session || 0
    '' + user + session + date + counter