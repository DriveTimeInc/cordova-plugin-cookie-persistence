/*global cordova, module*/

var channel = require('cordova/channel');

console.log('CookiePersistencePlugin - JS - Init');
console.log('CookiePersistencePlugin - JS - Cookies', document.cookie)

//When this code is run, just get the cookie and place it in the window
//But we need to notify when complete

function restoreCookiesAndLocalStorage(onSuccess, onError) {
  console.time("restoreCookies - start");
  fetchCookiesAndLocalStorage(function (res) {
    applyCookiesToBrowser(res[0]);
    applyLocalStorageToBrowser(res[1]);
    onSuccess(res);
  }, onError);
}

function restoreCookies(onSuccess, onError) {
  console.time("restoreCookies - start");
  fetchCookies(function (cookies) {
    applyCookiesToBrowser(cookies);
    onSuccess(cookies);
  }, onError);
}

function restoreLocalStorage(onSuccess, onError) {
  console.time("restoreLocalStorage - start");
  fetchLocalStorage(function (savedStorage) {
    applyLocalStorageToBrowser(savedStorage);
    onSuccess(savedStorage);
  }, onError);
}

function fetchCookiesAndLocalStorage(onSuccess, onError) {
  console.log('CookiePersistencePlugin - JS - retrieveCookiesAndLocalStorage');

  cordova.exec(function (res) {
    console.log('CookiePersistencePlugin - JS - retrieveCookiesAndLocalStorage successCallback called', res)
    console.timeEnd("retrieveCookiesAndLocalStorage - end");
    onSuccess(res);
  }, function (e) {
    console.log('CookiePersistencePlugin - JS - retrieveCookiesAndLocalStorage errorCallback called', e)
    onError(e);
  }, "CookiePersistence", "retrieveCookiesAndLocalStorage", []);
}

function fetchCookies(onSuccess, onError) {
  console.log('CookiePersistencePlugin - JS - restoreCookies');

  cordova.exec(function (res) {
    console.log('CookiePersistencePlugin - JS - restoreCookies successCallback called', res)
    console.timeEnd("restoreCookies - end");
    onSuccess(res);
  }, function (e) {
    console.log('CookiePersistencePlugin - JS - restoreCookies errorCallback called', e)
    onError(e);
  }, "CookiePersistence", "retrieveCookies", []);
}

function fetchLocalStorage(onSuccess, onError) {
  console.log('CookiePersistencePlugin - JS - retrieveLocalStorage');

  cordova.exec(function (res) {
    console.log('CookiePersistencePlugin - JS - retrieveLocalStorage successCallback called', res)
    console.timeEnd("retrieveLocalStorage - end");
    onSuccess(res);
  }, function (e) {
    console.log('CookiePersistencePlugin - JS - retrieveLocalStorage errorCallback called', e)
    onError(e);
  }, "CookiePersistence", "retrieveLocalStorage", []);
}

function writeCookies() {
  var cookies = document.cookie;
  console.log('CookiePersistencePlugin - JS - Pause', cookies);

  var successCallback = function (r) {
    console.log('CookiePersistencePlugin - JS - Pause successCallback called', r)
  }

  var errorCallback = function (e) {
    console.log('CookiePersistencePlugin - JS - Pause errorCallback called', e)
  }

  cordova.exec(successCallback, errorCallback, "CookiePersistence", "storeCookies", [cookies]);
}

function writeLocalStorage() {
  var localStorageText = getLocalStorageAsString();
  console.log('CookiePersistencePlugin - JS - Pause', localStorageText);

  var successCallback = function (r) {
    console.log('CookiePersistencePlugin - JS - Pause successCallback called', r)
  }

  var errorCallback = function (e) {
    console.log('CookiePersistencePlugin - JS - Pause errorCallback called', e)
  }

  cordova.exec(successCallback, errorCallback, "CookiePersistence", "storeLocalStorage", [localStorageText]);
}

// UTILS
function getLocalStorageAsString() {
  var localStorageObj = {}
  for (var i = 0; i < localStorage.length; i++) {
    localStorageObj[localStorage.key(i)] = localStorage.getItem(localStorage.key(i));
  }

  return JSON.stringify(localStorageObj);
}

function applyCookiesToBrowser(savedCookies) {
  if (!savedCookies || savedCookies.length < 1) return;
  savedCookies
    .trim(' ')
    .split(';')
    .forEach(function (savedCookie) {
      document.cookie = savedCookie;
    });
}

function applyLocalStorageToBrowser(savedStorage) {
  if (!savedStorage || savedStorage.length < 1) return;

  var parsedStorage = {};
  try {
    parsedStorage = JSON.parse(savedStorage);
  } catch (e) {
    console.error("cookie-persistence-plugin - applyLocalStorageToBrowser:", e);
  }

  Object.keys(parsedStorage).forEach(function (key) {
    localStorage.setItem(key, parsedStorage[key]);
  });
}

window.restoreCookies = restoreCookies;
window.restoreLocalStorage = restoreLocalStorage;
window.restoreCookiesAndLocalStorage = restoreCookiesAndLocalStorage;

channel.onPause.subscribe(writeCookies)
channel.onPause.subscribe(writeLocalStorage);
