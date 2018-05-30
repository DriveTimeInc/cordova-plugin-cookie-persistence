/*global cordova, module*/

var channel = require('cordova/channel');

console.log('CookiePersistencePlugin - JS - Init');
console.log('CookiePersistencePlugin - JS - Cookies', document.cookie)

//When this code is run, just get the cookie and place it in the window
//But we need to notify when complete

function restoreCookies(onSuccess, onError) {
  fetchCookies(function(cookies) {
    applyStoredCookiesToDocument(cookies);
    onSuccess(cookies);
  }, onError);
}

function fetchCookies(onSuccess, onError) {
  console.log('CookiePersistencePlugin - JS - restoreCookies');

  var successCallback = function(cookies) {
    console.log('CookiePersistencePlugin - JS - restoreCookies successCallback called', cookies)
    onSuccess(cookies);
  }

  var errorCallback = function(e) {
    console.log('CookiePersistencePlugin - JS - restoreCookies errorCallback called', e)
    onError(e);
  }

  cordova.exec(successCallback, errorCallback, "CookiePersistence", "retrieveCookies", []);
}

window.restoreCookies = restoreCookies;

function applyStoredCookiesToDocument(cookies) {
  if (cookies && cookies.length > 0) {
    console.log(`applyStoredCookiesToDocument start; cookies = ${cookies}; document.cookie = ${document.cookie}`);
    cookies
      .trim(' ')
      .split(';')
      .forEach(cookie =>
        document.cookie = cookie
      );
    console.log(`applyStoredCookiesToDocument end; cookies = ${cookies}; document.cookie = ${document.cookie}`);
  }
}

function writeCookies() {
  var cookies = document.cookie;
  console.log('CookiePersistencePlugin - JS - Pause', cookies);

  var successCallback = r => {
    console.log('CookiePersistencePlugin - JS - Pause successCallback called', r)
  }

  var errorCallback = e => {
    console.log('CookiePersistencePlugin - JS - Pause errorCallback called', e)
  }

  cordova.exec(successCallback, errorCallback, "CookiePersistence", "storeCookies", [cookies]);
}

channel.onPause.subscribe(writeCookies)
