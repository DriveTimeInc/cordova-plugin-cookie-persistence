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
- (void)storeCookies:(CDVInvokedUrlCommand*)command
{
    NSString* cookies = [[command arguments] objectAtIndex:0];

    [self overwriteTextFile:cookies fileName:@"cookies.txt"];

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:@"cookies saved to disk"];

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)storeLocalStorage:(CDVInvokedUrlCommand*)command
{
    NSString* localStorage = [[command arguments] objectAtIndex:0];
    NSString* localFileName = @"localstorage.txt";
    [self overwriteTextFile:localStorage fileName: localFileName];


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

    NSString* files[2];
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

    NSError *error = nil;
    NSString *content = [[NSString alloc] initWithContentsOfFile:filePath
                                            usedEncoding:nil
                                            error:&error];

    if (content) {
        return content;
    } else {
        NSLog(@"Error: %@", error);
        return @"";
    }
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

- (void)overwriteTextFile:(NSString *)fileContents fileName:(NSString *)fileName
{
    NSString* filePath = [self getFilePathByName: fileName];
    
    [fileContents writeToFile:filePath
                   atomically:NO
                     encoding:NSUTF8StringEncoding
                        error:nil];
    
}

@end
