´´´
/**
* ------------------ The Life-Cycle of a Composite Component ------------------
*
* - constructor: Initialization of state. The instance is now retained.
* - componentWillMount
* - render
* - [children's constructors]
* - [children's componentWillMount and render]
* - [children's componentDidMount]
* - componentDidMount
*
* Update Phases:
* - componentWillReceiveProps (only called if parent updated)
* - shouldComponentUpdate
* - componentWillUpdate
* - render
* - [children's constructors or receive props phases]
* - componentDidUpdate
*
* - componentWillUnmount
* - [children's componentWillUnmount]
* - [children destroyed]
* - (destroyed): The instance is now blank, released by React and ready for GC.
*
* -----------------------------------------------------------------------------
*/
´´´

> From https://github.com/facebook/react/blob/master/src/core/ReactCompositeComponent.js#L45
