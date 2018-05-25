/*global cordova, module*/

var channel = require('cordova/channel');

console.log('CookiePersistencePlugin - JS - Init');
console.log('CookiePersistencePlugin - JS - Cookies', document.cookie)
//alert(document.cookie)
var body = '<h1>'+document.cookie+'=HELLO WORLD</h1>'
setTimeout(function(){
  console.log('UPDATE')
  document.querySelector('body').prepend(body)
}, 5000)


//When this code is run, just get the cookie and place it in the window
//But we need to notify when complete

function retrieveCookies() {
  console.log('CookiePersistencePlugin - JS - retrieveCookies');

  var successCallback = cookies => {
    console.log('CookiePersistencePlugin - JS - retrieveCookies successCallback called', cookies)

    document.cookie = cookies;
  }

  var errorCallback = e => {
    console.log('CookiePersistencePlugin - JS - retrieveCookies errorCallback called', e)
  }

  cordova.exec(successCallback, errorCallback, "CookiePersistence", "retrieveCookies", []);

}
window.getCookies = retrieveCookies;


channel.onPause.subscribe(function () {
  var cookies = document.cookie;
  console.log('CookiePersistencePlugin - JS - Pause', cookies);

  var successCallback = r => {
    console.log('CookiePersistencePlugin - JS - Pause successCallback called', r)
  }

  var errorCallback = e => {
    console.log('CookiePersistencePlugin - JS - Pause errorCallback called', e)
  }

  cordova.exec(successCallback, errorCallback, "CookiePersistence", "storeCookies", [cookies]);
})
