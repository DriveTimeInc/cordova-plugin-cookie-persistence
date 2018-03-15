/*global cordova, module*/

var channel = require('cordova/channel');

console.log('CookiePersistencePlugin - JS - Init');
console.log('CookiePersistencePlugin - JS - Cookies', document.cookie)

channel.onPause.subscribe(function () {
  var cookies = document.cookie;
  var successCallback = r => {
    console.log('CookiePersistencePlugin - JS - successCallback called', r)
  }

  var errorCallback = e => {
    console.log('CookiePersistencePlugin - JS - errorCallback called', e)
  }
  console.log('CookiePersistencePlugin - JS - Pause', cookies);
  cordova.exec(successCallback, errorCallback, "CookiePersistence", "storeCookies", [cookies]);
})
