
(factory => {

  /* global define */
  if ('function' === typeof define && define.amd) {
    define(factory);
  } else if ('object' === typeof module && 'exports' in module) {
    module.exports = factory();
  } else if ('object' === typeof window) {
    window.bindRoot = factory();
  }

})(() => {

  // What not to process
  const blacklist = [
    'string',
    'undefined',
    'boolean',
    'number',
    'bigint',
    'symbol',
  ];

  const isBound = Symbol();

  // Return wrapped function
  return (org,root) => {
    root = root || org;

    // Recursive = easier here
    return (function link(ref) {

      // No null or blacklisted references
      const type = typeof ref;
      if (~blacklist.indexOf(type)) return ref;
      if (!ref) return ref;

      // Iterate through object/function
      Object.keys(ref).forEach(key => {

        // Check agains blacklist (yes, again)
        const property     = ref[key];
        const propertyType = typeof property;
        if (~blacklist.indexOf(propertyType)) return;
        if (!property) return;

        // Bind if it's an unbound function
        if (('function' === propertyType) && (!property[isBound])) {
          ref[key] = Object.assign(property.bind(root),property);
          Object.defineProperty(ref[key],isBound,{
            enumerable  : false,
            configurable: false,
            value       : true,
          });
        }

        // Iterate down
        // Use ref, because it might be just-modified
        link(ref[key]);
      });

      // Return produce
      return ref;
    })(org);
  };
});
