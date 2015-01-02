module.exports = ->
  @loadNpmTasks "grunt-module-index"

  @config "moduleIndex", {
    build:
      src: ["dist/"]
      dest: "dist/"
      options:
        pathPrefix: "./"
        omitDirs: ["dist"]
  }
