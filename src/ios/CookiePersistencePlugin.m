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

- (void)storeCookies:(CDVInvokedUrlCommand*)command
{
    NSString* cookies = [[command arguments] objectAtIndex:0];

    NSLog(@"CookiePersistencePlugin - OC - storeCookies - %@", cookies);

    [self overwriteFile: cookies];

    NSString* msg = [NSString stringWithFormat: @"Cookies Stored, %@", cookies];

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:msg];

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)retrieveCookies:(CDVInvokedUrlCommand*)command
{
    [self readFile];

    NSString* cookies = [self readFile];

    NSLog(@"CookiePersistencePlugin - OC - retrieveCookies - %@", cookies);

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:cookies];

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

-(void) overwriteFile:(NSString*)fileContents
{
    NSString *fileName = [self getFileName];

    [fileContents writeToFile:fileName
                    atomically:NO
                    encoding:NSUTF8StringEncoding
                    error:nil];

}

-(NSString *) readFile
{
    NSString *fileName = [self getFileName];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                            usedEncoding:nil
                                            error:nil];

    NSLog(@"CONTENT:%@",content);

    return content;
}

-(NSString *) getFileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
                    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *fileName = [NSString stringWithFormat:@"%@/cookies.txt",
                                                    documentsDirectory];

    return fileName;
}

-(void) displayCookies:(NSString*)content
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cookies"
                                                    message:content
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
