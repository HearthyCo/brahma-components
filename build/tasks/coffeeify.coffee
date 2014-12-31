module.exports = ->
  @loadNpmTasks 'grunt-contrib-coffeeify'

  @config "coffeeify", {
    options: {}
    files: [
      {
        src:['components/index.coffee'], dest:'components/index.js'
      },
      {
        src:['**/*.coffee', '**/*.js'], dest:'dist/app.js'
      }
    ]
  }