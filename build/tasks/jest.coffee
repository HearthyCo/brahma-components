module.exports = ->
  @loadNpmTasks "grunt-jest"

  @config "jest.options", {
    config: ".jestrc"
  }