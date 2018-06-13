#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface CookiePersistencePlugin : CDVPlugin

- (void)pluginInitialize;
- (void)storeCookies:(CDVInvokedUrlCommand*)command;
- (void)storeLocalStorage:(CDVInvokedUrlCommand*)command;
- (void)retrieveCookiesAndLocalStorage:(CDVInvokedUrlCommand*)command;
- (void)retrieveCookies:(CDVInvokedUrlCommand*)command;
- (void)retrieveLocalStorage:(CDVInvokedUrlCommand*)command;

@end
