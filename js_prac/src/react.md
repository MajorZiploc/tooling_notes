?: Explain the lifecycle methods of React components in detail.

A: Some of the most important lifecycle methods are:
  componentWillMount() – Executed just before rendering takes place both on the client as well as server-side.
  componentDidMount() – Executed on the client side only after the first render.
  componentWillReceiveProps() – Invoked as soon as the props are received from the parent class and before another render is called.
  shouldComponentUpdate() – Returns true or false value based on certain conditions. If you want your component to update, return true else return false. By default, it returns false.
  componentWillUpdate() – Called just before rendering takes place in the DOM.
  componentDidUpdate() – Called immediately after rendering takes place.
  componentWillUnmount() – Called after the component is unmounted from the DOM. It is used to clear up the memory spaces.
