module.exports = ->

  @loadNpmTasks "grunt-contrib-watch"

  @config "watch",
    options:
      spawn: false
    coffee:
      files: "src/**/*.coffee"
      tasks: ["build"]
