React = require 'react/addons'
_ = require 'underscore'

SignupForm = React.createFactory require '../components/user/signupForm'

{ div, span, a } = React.DOM

module.exports = React.createClass

  render: ->
    (div {},
      (SignupForm())
      (a {href: "/alex", className: "linkAlex"},
        "Álex "
        (span {}, "Ubago")
      )
    )