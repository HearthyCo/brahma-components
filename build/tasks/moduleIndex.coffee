module.exports = ->
  @loadNpmTasks "grunt-module-index"

  @config "moduleIndex", {
    build:
      src: ["dist/**/*.js"]
      dest: "dist/"
      options:
        pathPrefix: "./"
        omitDirs: ["dist"]
  }
