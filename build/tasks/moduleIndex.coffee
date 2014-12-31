module.exports = ->
  @loadNpmTasks "grunt-module-index"

  @config "moduleIndex", {
    build:
      src: ["components", "mixins", "actions", "dispatcher", "stores"]
  }
