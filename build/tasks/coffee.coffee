module.exports = ->
  @loadNpmTasks 'grunt-contrib-coffee'

  # Wipe out previous builds and test reporting.
  @config "coffee", {
    options:
      bare: true
    build:
      expand: true
      cwd: 'src'
      src: ['**/*.coffee']
      dest: 'dist/'
      ext: '.js'
  }
