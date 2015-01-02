module.exports = ->
  @loadNpmTasks 'grunt-coffeelint'

  @config "coffeelint", {
    options:
      max_line_length:
        level: 'warn'
    src:['src/**/*.coffee']
  }