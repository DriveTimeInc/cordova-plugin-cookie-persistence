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
    NSString* filePath = [self getFilePathByName: fileName];

    [fileContents writeToFile:filePath
                    atomically:NO
                    encoding:NSUTF8StringEncoding
                    error:nil];

}

- (void)storeCookies:(CDVInvokedUrlCommand*)command
{
    NSString* cookies = [[command arguments] objectAtIndex:0];

    [self overwriteFile: cookies];

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:@"cookies saved to disk"];

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)storeLocalStorage:(CDVInvokedUrlCommand*)command
{
    NSString* localStorage = [[command arguments] objectAtIndex:0];

    [self overwriteFile: localStorage];


    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:@"localStorage saved to disk"];

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








// retrieveCookiesAndLocalStorage()
// retrieveFile('cookies.txt');
// retrieveFile('localstorage.txt');
// return [cookies, localStorage]
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

// retrieveCookies()
// retrieveFile('cookies.txt');
// return cookies string
- (void)retrieveCookies:(CDVInvokedUrlCommand*)command
{
    NSString* file = [self readFileByName:@"cookies.txt"];

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:file];

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}




// retrieveLocalStorage()
// retrieveFile('localstorage.txt');
// return localStorage string
- (void)retrieveLocalStorage:(CDVInvokedUrlCommand*)command
{
    NSString* file = [self readFileByName:@"localstorage.txt"];

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:file];

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
// retrieveFile(name)
// getFilePathByName(name);
// getFileByPath(filePath)
// return contents string
-(NSString *) readFileByName:(NSString*)fileNameText
{
    NSString* filePath = [self getFilePathByName: fileNameText];

    NSString *content = [[NSString alloc] initWithContentsOfFile:filePath
                                            usedEncoding:nil
                                            error:nil];

    return content;
}

// checked
-(NSString *) getFilePathByName: (NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
                    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *filePath = [NSString stringWithFormat:@"%@\/%@",
                             documentsDirectory, fileName];

    return filePath;
}









// GET TEXT
// - (void)retrieveStorage:(CDVInvokedUrlCommand*)command
// {
//     NSString* cookies = [self readFileByName: @"cookies.txt"];

//     NSString* localStorage = [self readFileByName: @"localstorage.txt"];

//     if (cookies != nil && localStorage != nil) {
//         NSLog(@"CookiePersistencePlugin - OC - retrieveCookies - %@", cookies);

//         NSString *files[2];
//         if (cookies) {
//             files[0] = cookies;
//         }

//         if (localStorage) {
//             files[1] = localStorage;
//         }

//         NSArray *res = [NSArray arrayWithObjects:files count:2];

//         CDVPluginResult* result = [CDVPluginResult
//                                    resultWithStatus:CDVCommandStatus_OK
//                                    messageAsArray:res];

//         [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
//     } else {
//         CDVPluginResult* result = [CDVPluginResult
//                                    resultWithStatus:CDVCommandStatus_OK
//                                    messageAsString:@"No files found"];

//         [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
//     }
// }


// -(NSString *) readFileByName:(NSString*)fileNameText
// {
//     NSString* filePath = [self getFilePathByname: fileNameText];

//     NSString *content = [[NSString alloc] initWithContentsOfFile:filePath
//                                             usedEncoding:nil
//                                             error:nil];

//     NSLog(@"readFileByName::%@",content);

//     return content;
// }




// -(NSString *) readFile
// {
//     NSString *fileName = [self getFileName];
//     NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
//                                             usedEncoding:nil
//                                             error:nil];

//     NSLog(@"CONTENT:%@",content);

//     return content;
// }

// -(NSString *) getFileName
// {
//     NSArray *paths = NSSearchPathForDirectoriesInDomains
//                     (NSDocumentDirectory, NSUserDomainMask, YES);
//     NSString *documentsDirectory = [paths objectAtIndex:0];

//     NSString *fileName = [NSString stringWithFormat:@"%@/cookies.txt",
//                                                     documentsDirectory];

//     return fileName;
// }




@end
