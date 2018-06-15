/*global cordova, module*/


var channel = require('cordova/channel');
var Future = require('fluture');
var S = require('sanctuary');
var utils = require('./CookieUtils');

console.log('CookiePersistencePlugin - JS - Init');

window.restoreCookies = utils.restoreCookies;
window.restoreLocalStorage = utils.restoreLocalStorage;
window.restoreCookiesAndLocalStorage = utils.restoreCookiesAndLocalStorage;

channel.onPause.subscribe(utils.storeCookies)
channel.onPause.subscribe(utils.storeLocalStorage);
