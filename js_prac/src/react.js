// props spread and repass the rest example
//
const Modal = ({ visible = false, ...rest }) => {
  useEffect(() => {
    if (mRoot.firstChild !== modalContainer) {
      mRoot.appendChild(modalContainer);
    }
    mRoot.appendChild(modalContainer);
    return () => {
      if (mRoot.firstChild === modalContainer) {
        mRoot.removeChild(modalContainer);
      }
    };
  }, []);
  return visible ? createPortal(<ModalView {...rest} />, modalContainer) : null;
};
