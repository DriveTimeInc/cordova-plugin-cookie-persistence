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



// REFACTOR GENERIC STORING
- (void)storeText:(CDVInvokedUrlCommand*)command
{

    NSArray* cookieArray = [[command arguments] objectAtIndex:0];
    NSArray* localStorageArray = [[command arguments] objectAtIndex:1];

    NSString* cookies = [cookieArray objectAtIndex:1];
    NSString* cookieText = [cookieArray objectAtIndex:0];

    NSString* localStorage = [localStorageArray objectAtIndex:1];
    NSString* localStorageText = [localStorageArray objectAtIndex:0];

    NSLog(@"CookiePersistencePlugin - OC - storeText - %@", cookies);

    [self overwriteTextFile: cookies
                   fileName: cookieText];

    NSString* msg = [NSString stringWithFormat: @"cookies saved, %@", cookies];


    [self overwriteTextFile: localStorage
                   fileName: localStorageText];

//    NSString* msg2 = [NSString stringWithFormat: @"local storage saved, %@", localStorage];

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

    // NSString *filePath = [NSString stringWithFormat:@"     %1@    /   %2@     ", documentsDirectory, fileName];

    // documentsDirectory = [documentsDirectory stringByAppendString:@"/"];
    // documentsDirectory = [documentsDirectory stringByAppendString:fileName];

    NSString *filePath = [NSString stringWithFormat:@"%@\/%@",
                             documentsDirectory, fileName];



    return filePath;
}


// END STORE COOKIES





// STORING COOKIES
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

-(void) overwriteFile:(NSString*)fileContents
{
    NSString *fileName = [self getFileName];

    [fileContents writeToFile:fileName
                    atomically:NO
                    encoding:NSUTF8StringEncoding
                    error:nil];

}
// END STORE COOKIES







- (void)retrieveStorage:(CDVInvokedUrlCommand*)command
{
    // self readFileByName(cookies)
    NSString* cookies = [self readFileByName: @"cookies.txt"];

    // self readFileByName(localStorage)
    NSString* localStorage = [self readFileByName: @"localstorage.txt"];

    
    if (cookies != nil && localStorage != nil) {
        NSString *files[2];
        files[0] = cookies;
        files[1] = localStorage;
        NSArray *res = [NSArray arrayWithObjects:files count:2];
    
    
        CDVPluginResult* result = [CDVPluginResult
                                   resultWithStatus:CDVCommandStatus_OK
                                   messageAsArray:res];
        
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    } else {
        NSLog(@"CookiePersistencePlugin - OC - retrieveCookies - %@", cookies);
        
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


-(NSString *) getFileByNa
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
                    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *fileName = [NSString stringWithFormat:@"%@/cookies.txt",
                                                    documentsDirectory];

    return fileName;
}

















// GETTING COOKIES
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

-(NSString *) readFile
{
    NSString *fileName = [self getFileName];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                            usedEncoding:nil
                                            error:nil];

    NSLog(@"CONTENT:%@",content);

    return content;
}
// END GET COOKIES



// UTIL FUNCTIONS
-(NSString *) getFileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
                    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *fileName = [NSString stringWithFormat:@"%@/cookies.txt",
                                                    documentsDirectory];

    return fileName;
}
// END UTILS FUNCTIONS





// TEST FUNCTIONS

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
