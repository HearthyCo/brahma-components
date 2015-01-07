module.exports = ->

  # Load task configurations.
  @loadTasks "build/tasks"

  # When running the default Grunt command, just lint the code.
  @registerTask "default", [
    "clean"
    "coffeelint"
    "coffee"
    "clean:tests"
    #"jshint"
    "moduleIndex"
  ]
