/*global cordova, module*/

var channel = require('cordova/channel');

console.log('CookiePersistencePlugin - JS - Init');
console.log('CookiePersistencePlugin - JS - Cookies', document.cookie)

//When this code is run, just get the cookie and place it in the window
//But we need to notify when complete

function restoreCookiesAndLocalStorage(onSuccess, onError) {
  console.time("restoreCookies - start");
  fetchCookiesAndLocalStorage(function(res) {
    applyCookiesAndLocalStorageToBrowser(res);
    onSuccess(res);
  }, onError);
}

function restoreCookies(onSuccess, onError) {
  console.time("restoreCookies - start");
  fetchCookies(function(cookies) {
    refreshCookies(cookies);
    onSuccess(cookies);
  }, onError);
}

function restoreLocalStorage(onSuccess, onError) {
  console.time("restoreCookies - start");
  fetchLocalStorage(function(savedStorage) {
    refreshLocalStorage(savedStorage);
    onSuccess(savedStorage);
  }, onError);
}

function fetchCookiesAndLocalStorage(onSuccess, onError) {
  console.log('CookiePersistencePlugin - JS - restoreCookies');

  var successCallback = function(res) {
    console.timeEnd("restoreCookies - end");
    console.log('CookiePersistencePlugin - JS - restoreCookies successCallback called', res)
    onSuccess(res);
  }

  var errorCallback = function(e) {
    console.log('CookiePersistencePlugin - JS - restoreCookies errorCallback called', e)
    onError(e);
  }

  cordova.exec(successCallback, errorCallback, "CookiePersistence", "retrieveCookiesAndLocalStorage", []);
}

function applyCookiesAndLocalStorageToBrowser(res) {
  refreshCookies(res[0]);
  refreshLocalStorage(res[1]);
}

function refreshCookies(savedCookies) {
  if (!savedCookies || savedCookies.length < 1) return;
  savedCookies
  .trim(' ')
  .split(';')
  .forEach(savedCookie =>
    document.cookie = savedCookie
  );
}

function refreshLocalStorage(savedStorage) {
  if (!savedStorage || savedStorage.length < 1) return;

  var parsedStorage = {};
  try {
    parsedStorage = JSON.parse(savedStorage);
  } catch(e) {
    throw e;
    // come back to this? bubble it up
  }

  Object.keys(parsedStorage).forEach(function(key) {
    localStorage.setItem(key, parsedStorage[key]);
  });
}

function getLocalStorageAsString() {

  var localStorageObj = {}
  for (var i = 0; i < localStorage.length; i++) {
    localStorageObj[localStorage.key(i)] = localStorage.getItem(localStorage.key(i));
  }

  return JSON.stringify(localStorageObj);
}

function writeCookies() {
  var cookies = document.cookie;
  console.log('CookiePersistencePlugin - JS - Pause', cookies);

  var successCallback = function(r) {
    console.log('CookiePersistencePlugin - JS - Pause successCallback called', r)
  }

  var errorCallback = function(e) {
    console.log('CookiePersistencePlugin - JS - Pause errorCallback called', e)
  }

  cordova.exec(successCallback, errorCallback, "CookiePersistence", "storeCookies", [cookies]);
}

function writeLocalStorage() {
  var localStorageText = getLocalStorageAsString();
  console.log('CookiePersistencePlugin - JS - Pause', localStorageText);

  var successCallback = function(r) {
    console.log('CookiePersistencePlugin - JS - Pause successCallback called', r)
  }

  var errorCallback = function(e) {
    console.log('CookiePersistencePlugin - JS - Pause errorCallback called', e)
  }

  cordova.exec(successCallback, errorCallback, "CookiePersistence", "storeLocalStorage", [localStorageText]);
}

window.restoreCookies = restoreCookies;
window.restoreLocalStorage = restoreLocalStorage;
window.restoreCookiesAndLocalStorage = restoreCookiesAndLocalStorage;

channel.onPause.subscribe(writeCookies)
channel.onPause.subscribe(writeLocalStorage);
