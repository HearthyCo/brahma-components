module.exports = ->
  @loadNpmTasks "grunt-contrib-jshint"

  # Run your source code through JSHint's defaults.
  @config "jshint", {
    options:
      reporter: require("jshint-stylish")
      curly: true
      eqeqeq: true
      forin: true
      immed: true
      latedef: true
      laxcomma: true
      newcap: true
      noarg: true
      smarttabs: true
      sub: true
      undef: true
      eqnull: true
      node: true
    src:[
      "build/**/*.js"
      "index.js"
    ]
  }
