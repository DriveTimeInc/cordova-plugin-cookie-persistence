#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface CookiePersistencePlugin : CDVPlugin

- (void)pluginInitialize;
- (void)storeCookies:(CDVInvokedUrlCommand*)command;
- (void)retrieveCookies:(CDVInvokedUrlCommand*)command;

@end
