module.exports = ->
  @loadNpmTasks 'grunt-coffeelint'

  @config "coffeelint",
    app:
      options:
        undefined_variables:
          module: "coffeelint-undefined-variables"
          level: "warn"
          globals: ["module", "console", "process", "require",
            "ex", "window", "props"]
        variable_scope:
          module: "coffeelint-variable-scope"
          level: "warn"
      src:['src/**/*.coffee','!src/**/__tests__/*.coffee']
    tests:
      options:
        undefined_variables:
          module: "coffeelint-undefined-variables"
          level: "warn"
          globals: ["module", "console", "process", "require",
            "ex", "window", "props", "jest", "describe", "it", "expect"]
        variable_scope:
          module: "coffeelint-variable-scope"
          level: "warn"
      src:['src/**/__tests__/*.coffee']
