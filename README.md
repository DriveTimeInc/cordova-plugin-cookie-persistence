# Cordova Plugin Cookie Persistence

Cordova Plugin that injects saved cookies on app start, and saves cookies on pause.

## Description

For Android and iOS webviews, cookies will not be persisted across multiple app open/closes. This plugin will save cookies on app exit and restore those cookies on app re-start.

The plugin will push the cookies into the webview before the first http request is made so external site requests will include the cookies in the first request.

## Details

### Android

The cookies will be stored in a private `.txt` file.

### iOS

IN PROGRESS: This is still being worked on.
