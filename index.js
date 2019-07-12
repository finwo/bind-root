const isBound = Symbol();

module.exports = function(org) {
  return (function link(ref) {
    Object.keys(ref).forEach(key => {
      let fn;
      switch(typeof ref[key]) {
        case 'function':
          fn = ref[key];
          if(fn[isBound]) {
            link(ref[key]);
          } else {
            ref[key] = ref[key].bind(org);
            Object.defineProperty(ref[key], isBound, {
              enumerable  : false,
              configurable: true,
              get         : () => true,
              set         : () => {},
            });
            Object.assign(ref[key],link(fn));
          }
          break;
        case 'object':
          if (!ref[key]) break;
          link(ref[key]);
          break;
        default:
          break;
      }
    });
    return ref;
  })(org);
};
