var Future = require('fluture');
var S = require('sanctuary')

var cordovaMock = {
  exec: (res, rej, c, m) => {res("abc=def; hij=klmn; ")}
}
cordova = cordovaMock
document = {}
localStorage = {
  setItem: function (a,b) {},
  getItem: function(){},
  length: 0
}

// UTILS
var isTruthy = i => i ? true : false
var trim = s => (s ? s : '').trim(' ')
var mapObject = fn => obj =>
  Object.keys(obj).map(k => fn(obj[k], k))
var parseJson = json => {
    try {
      return S.Right (JSON.parse(json));
    } catch (e) {
      return S.Left (`Failed to parse json. Error: ${e}`)
    }
  }
var parseCookies = cookies =>
  trim(cookies)
    .split(';')
    .filter(isTruthy)
    .map(trim)
var arrayToPair = arr =>
  S.Pair (arr[0]) (arr[1])

//CONSTS
var COOKIE_PERSISTENCE = 'CookiePersistence'
var RETRIEVE_COOKIES_AND_LOCALSTORAGE = 'retrieveCookiesAndLocalStorage'
var RETRIEVE_COOKIES = 'retrieveCookiesAndLocalStorage'
var RETRIEVE_LOCALSTORAGE = 'retrieveCookiesAndLocalStorage'
var STORE_COOKIES = 'storeCookies'
var STORE_LOCALSTORAGE = 'storeLocalStorage'

/* Browser IO */
var setCookie = cookie => {
  console.log('setCookie', cookie);
  document.cookie = cookie
}
var setCookies = cookies => {
  console.log('cookies', cookies)
  S.map (setCookie) (cookies)
  return cookies
}

var setLocalStorage = (key, value) => {
  console.log('setLocalStorage', key,value);
  localStorage.setItem(key, value);
}
var setLocalStorages = localStorage => {
  mapObject ((v,k) => setLocalStorage(k,v)) (localStorage)
  return localStorage;
}

var fetchCookiesAsString = () =>
  document.cookies

var extractLocalStorage = () => {
  var localStorageObj = {}
  for (var i = 0; i < localStorage.length; i++) {
    localStorageObj[localStorage.key(i)] = localStorage.getItem(localStorage.key(i));
  }
  return localStorageObj
}
var fetchLocalStorageAsString = () =>
  JSON.stringify(extractLocalStorage())

/* Hander Utils */
var handleCookiesAndLocalStorage = pair =>
  S.bimap (cookiesHandler) (localStorageHandler) (pair)

var cookiesHandler = cookies =>
  setCookies(parseCookies(cookies))

var localStorageHandler = localStorage =>
  S.map (setLocalStorages) (parseJson(localStorage))

/* Cordova Calls */
var execCordovaCall = method => params =>
    Future(function (reject, resolve) {
      params
        ? cordova.exec(resolve, reject, COOKIE_PERSISTENCE, method, params)
        : cordova.exec(resolve, reject, COOKIE_PERSISTENCE, method);
    })

var fetchCookiesAndLocalStorage = () =>
  arrayToPair(execCordovaCall(RETRIEVE_COOKIES_AND_LOCALSTORAGE) ())
var fetchCookies = () =>
  execCordovaCall(RETRIEVE_COOKIES) ()
var fetchLocalStorage = () =>
  execCordovaCall(RETRIEVE_LOCALSTORAGE) ()
var persistCookies = cookiesAsString =>
  execCordovaCall(STORE_COOKIES) ([cookiesAsString])
var persistLocalStorage = localStorageAsString =>
  execCordovaCall(STORE_LOCALSTORAGE) ([localStorageAsString])

/* External API */
var restoreCookiesAndLocalStorage = (res, rej) =>
  fetchCookiesAndLocalStorage()
    .map(handleCookiesAndLocalStorage)
    .fork(rej, res);

var restoreCookies = (res, rej) =>
  fetchCookies()
    .map(cookiesHandler)
    .fork(rej, res);

var restoreLocalStorage = (res, rej) =>
  fetchLocalStorage()
    .map(localStorageHandler)
    .fork(rej, res);

var storeCookies = (res, rej) =>
  persistCookies(fetchCookiesAsString())
    .fork(rej, res);

var storeLocalStorage = (res, rej) =>
  persistLocalStorage(fetchLocalStorageAsString())
    .fork(rej, res);

exports = {
  restoreCookiesAndLocalStorage,
  restoreCookies,
  restoreLocalStorage,
  storeCookies,
  storeLocalStorage
}

/* For Testing
   To use:
    $ node www/CookieUtils.js
*/

// var obj = "{\"lkj\":\"iuy\", \"uyt\":\"hgf\"}"
// var pair = S.Pair ("asd=qwe; ert=dfg; ") (obj)

// console.log(handleCookiesAndLocalStorage(pair))

