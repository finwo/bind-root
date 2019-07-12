# bind-root

bind a single js object to all underlying functions

---

#### Why on earth would you use this?

So all functions from within an object have the same `this` variable, allowing
you to use exactly the same code throughout the object to perform some action.

---

## Install

```sh
npm install --save bind-root
```

## Usage

```js
const bindRoot = require('bind-root');

// Define placeholder api object
const yourApi = {
  v1: {
    account: {
      get: function(id) {
        // Your code here
      },
      me: function() {
        return this.account.get(null);
      },
    },
  },
};

// Bind all functions to the root api
bindRoot(yourApi.v1);
```
