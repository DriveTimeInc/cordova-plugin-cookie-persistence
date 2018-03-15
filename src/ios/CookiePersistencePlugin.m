#import <Cordova/NSDictionary+CordovaPreferences.h>
#import <Cordova/CDVConfigParser.h>

#import <Foundation/Foundation.h>

#import "CDVWKProcessPoolFactory.h"
#import "CDVWKWebViewEngine.h"
#import "CookiePersistencePlugin.h"

@implementation CookiePersistencePlugin {
    NSString* startPageUrl;
}

- (void)pluginInitialize
{
    NSLog(@"CookiePersistencePlugin - Initialized");
}

- (void)storeCookies:(CDVInvokedUrlCommand*)command
{
    NSString* cookies = [[command arguments] objectAtIndex:0];

    NSLog(@"CookiePersistencePlugin - storeCookies - %@", cookies);

    //TODO: Persist the cookies somehow (file.txt)

    NSString* msg = [NSString stringWithFormat: @"Cookies Stored, %@", cookies];

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:msg];

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end
