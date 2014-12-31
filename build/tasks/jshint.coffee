module.exports = ->
  @loadNpmTasks "grunt-contrib-jshint"

  # Run your source code through JSHint's defaults.
  @config "jshint", [
    "modules/**/*.js"
    "components/**/*.js"
    "mixins/**/*.js"
  ]
