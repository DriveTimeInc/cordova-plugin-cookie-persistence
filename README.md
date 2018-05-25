# Cordova Plugin Cookie Persistence

Cordova Plugin that injects saved cookies on app start, and saves cookies on pause.

## Install

```
cordova plugin add https://github.com/DriveTimeInc/cordova-plugin-cookie-persistence
```

## Description

For Android and iOS webviews, cookies will not be persisted across multiple app open/closes. This plugin will save cookies on app exit and restore those cookies on app re-start.

The plugin will push the cookies into the webview before the first http request is made so external site requests will include the cookies in the first request.

## Details

### Android

The cookies will be stored in a private `.txt` file.

### iOS

It is possible that this plugin is not required for cookies on iOS. It appears from very basic testing that when an app is killed the cookies are persisted. It is unknown how long this is for.

Cookies are saved to a text file when an app is paused.

To get the cookies out, you can call `window.getCookies()`.

**NOTE** This may be a problem for MOST use cases though. [See PR #4 for more details.](https://github.com/DriveTimeInc/cordova-plugin-cookie-persistence/issues/4)
