#import <Cordova/NSDictionary+CordovaPreferences.h>
#import <Cordova/CDVConfigParser.h>

#import <Foundation/Foundation.h>
#import <stdio.h>

#import "CDVWKProcessPoolFactory.h"
#import "CDVWKWebViewEngine.h"
#import "CookiePersistencePlugin.h"

@implementation CookiePersistencePlugin {
    NSString* startPageUrl;
}

- (void)pluginInitialize
{
    NSLog(@"CookiePersistencePlugin - OC - Initialized");
}

////////////////////// STORE //////////////////////
// - (void)storeCookiesAndLocalStorage:(CDVInvokedUrlCommand*)command
// {
//     NSString* cookies = [[command arguments] objectAtIndex:0];
//     [self storeCookies: cookies];

//     NSString* localStorage = [[command arguments] objectAtIndex:1];
//     [self storeLocalStorage: localStorage];

//     NSString* msg = [NSString stringWithFormat: @"cookies saved, %@; localStorage saved %@", cookies, localStorage];

//     CDVPluginResult* result = [CDVPluginResult
//                                resultWithStatus:CDVCommandStatus_OK
//                                messageAsString:msg];

//     [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
// }

- (void)storeCookies:(CDVInvokedUrlCommand*)command
{
    NSString* cookies = [[command arguments] objectAtIndex:0];

    [self overWriteTextFile: cookies
                   fileName: @"cookies.txt"];

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:@"cookies saved to disk"];

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)storeLocalStorage:(CDVInvokedUrlCommand*)command
{
    NSString* localStorage = [[command arguments] objectAtIndex:0];

    [self overWriteTextFile: localStorage
                   fileName: @"localstorage.txt"];


    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:@"localStorage saved to disk"];

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

////////////////////// RETRIEVE //////////////////////
- (void)retrieveCookiesAndLocalStorage:(CDVInvokedUrlCommand*)command
{
    NSString* cookies = [self readFileByName:@"cookies.txt"];
    NSString* localStorage = [self readFileByName:@"localstorage.txt"];

    NSString *files[2];
    files[0] = cookies;
    files[1] = localStorage;

    NSArray *res = [NSArray arrayWithObjects:files count:2];

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsArray:res];

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)retrieveCookies:(CDVInvokedUrlCommand*)command
{
    NSString* file = [self readFileByName:@"cookies.txt"];

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:file];

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)retrieveLocalStorage:(CDVInvokedUrlCommand*)command
{
    NSString* file = [self readFileByName:@"localstorage.txt"];

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:file];

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

////////////////////// UTILS //////////////////////
-(NSString *) readFileByName:(NSString*)fileNameText
{
    NSString* filePath = [self getFilePathByName: fileNameText];

    NSString *content = [[NSString alloc] initWithContentsOfFile:filePath
                                            usedEncoding:nil
                                            error:nil];

    return content;
}

-(NSString *) getFilePathByName: (NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
                    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *filePath = [NSString stringWithFormat:@"%@\/%@",
                             documentsDirectory, fileName];

    return filePath;
}

-(void) overwriteTextFile:(NSString*)fileContents fileName:(NSString*)fileName
{
    NSString* filePath = [self getFilePathByName: fileName];

    [fileContents writeToFile:filePath
                    atomically:NO
                    encoding:NSUTF8StringEncoding
                    error:nil];

}

@end
