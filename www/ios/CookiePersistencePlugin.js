/*global cordova, module*/

var channel = require('cordova/channel');

console.log('CookiePersistencePlugin - JS - Init');
console.log('CookiePersistencePlugin - JS - Cookies', document.cookie)

//When this code is run, just get the cookie and place it in the window
//But we need to notify when complete

function restoreCookies(onSuccess, onError) {
  fetchCookiesAndLocalStorage(function(res) {
    applyCookiesAndLocalStorageToBrowser(res);
    onSuccess(res);
  }, onError);
}

function fetchCookiesAndLocalStorage(onSuccess, onError) {
  console.log('CookiePersistencePlugin - JS - restoreCookies');

  var successCallback = function(res) {
    console.log('CookiePersistencePlugin - JS - restoreCookies successCallback called', res)
    onSuccess(res);
  }

  var errorCallback = function(e) {
    console.log('CookiePersistencePlugin - JS - restoreCookies errorCallback called', e)
    onError(e);
  }

  cordova.exec(successCallback, errorCallback, "CookiePersistence", "retrieveStorage", []);
}

window.restoreCookies = restoreCookies;

function applyCookiesAndLocalStorageToBrowser(res) {
  var locStorage = res[1];
  if (locStorage && locStorage.length > 0) {
    var keyValuePairs = locStorage
      .split(';')
      .filter(function(item) {
      return item !== "";
    });

    for (var i = 0; i < keyValuePairs.length; i++) {
      var pair = keyValuePairs[i].split('=');
      localStorage.setItem(pair[0], pair[1]);
    }
  }

  var cookies = res[0];
  if (cookies && cookies.length > 0) {
    cookies
      .trim(' ')
      .split(';')
      .forEach(cookie =>
        document.cookie = cookie
      );
  }
}

function writeCookies() {
  var cookies = document.cookie;

  var localStorageText = "";
  for (var i = 0; i < localStorage.length; i++) {
    localStorageText +=  localStorage.key(i) + '=' + localStorage.getItem(localStorage.key(i)) + ';';
  }

  console.log('CookiePersistencePlugin - JS - Pause', cookies);
  console.log('CookiePersistencePlugin - JS - Pause', localStorageText);

  var successCallback = r => {
    console.log('CookiePersistencePlugin - JS - Pause successCallback called', r)
  }

  var errorCallback = e => {
    console.log('CookiePersistencePlugin - JS - Pause errorCallback called', e)
  }

  cordova.exec(successCallback, errorCallback, "CookiePersistence", "storeText", [["cookies.txt", cookies], ["localstorage.txt", localStorageText]]);
}

channel.onPause.subscribe(writeCookies)
