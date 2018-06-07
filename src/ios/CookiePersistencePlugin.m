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


// STORE TEXT
- (void)storeText:(CDVInvokedUrlCommand*)command
{
    NSArray* cookieArray = [[command arguments] objectAtIndex:0];
    NSArray* localStorageArray = [[command arguments] objectAtIndex:1];

    NSString* cookies = [cookieArray objectAtIndex:1];
    NSString* cookieText = [cookieArray objectAtIndex:0];

    [self overwriteTextFile: cookies
                   fileName: cookieText];

    NSString* localStorage = [localStorageArray objectAtIndex:1];
    NSString* localStorageText = [localStorageArray objectAtIndex:0];

    [self overwriteTextFile: localStorage
                   fileName: localStorageText];

    NSString* msg = [NSString stringWithFormat: @"cookies saved, %@; localStorage saved %@", cookies, localStorage];

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:msg];

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

-(void) overwriteTextFile:(NSString*)fileContents fileName:(NSString*)fileName
{
    NSString* filePath = [self getFilePathByname: fileName];

    [fileContents writeToFile:filePath
                    atomically:NO
                    encoding:NSUTF8StringEncoding
                    error:nil];

}

-(NSString *) getFilePathByname: (NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
                    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *filePath = [NSString stringWithFormat:@"%@\/%@",
                             documentsDirectory, fileName];

    return filePath;
}



// GET TEXT
- (void)retrieveStorage:(CDVInvokedUrlCommand*)command
{
    NSString* cookies = [self readFileByName: @"cookies.txt"];

    NSString* localStorage = [self readFileByName: @"localstorage.txt"];

    if (cookies != nil && localStorage != nil) {
        NSLog(@"CookiePersistencePlugin - OC - retrieveCookies - %@", cookies);

        NSString *files[2];
        files[0] = cookies;
        files[1] = localStorage;
        NSArray *res = [NSArray arrayWithObjects:files count:2];

        CDVPluginResult* result = [CDVPluginResult
                                   resultWithStatus:CDVCommandStatus_OK
                                   messageAsArray:res];

        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    } else {
        CDVPluginResult* result = [CDVPluginResult
                                   resultWithStatus:CDVCommandStatus_OK
                                   messageAsString:cookies];

        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }
}

-(NSString *) readFileByName:(NSString*)fileNameText
{
    NSString* filePath = [self getFilePathByname: fileNameText];

    NSString *content = [[NSString alloc] initWithContentsOfFile:filePath
                                            usedEncoding:nil
                                            error:nil];

    NSLog(@"readFileByName::%@",content);

    return content;
}

@end
