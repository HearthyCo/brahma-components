module.exports = ->
  @loadNpmTasks "grunt-contrib-clean"

  # Wipe out previous builds and test reporting.
  @config "clean", [
    "dist/*"
  ]

  @config "clean.tests", [
    "dist/**/__tests__/*"
  ]
