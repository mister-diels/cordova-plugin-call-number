#import <Cordova/CDVPlugin.h>
#import "CFCallNumber.h"

@implementation CFCallNumber

- (void) callNumber:(CDVInvokedUrlCommand*)command {

    [self.commandDelegate runInBackground:^{

        CDVPluginResult* pluginResult = nil;
        NSString* number = [command.arguments objectAtIndex:0];
        number = [number stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

        if (![number hasPrefix:@"tel:"]) {
            number = [NSString stringWithFormat:@"tel:%@", number];
        }

        NSURL *url = [NSURL URLWithString:number];
        if (![[UIApplication sharedApplication] canOpenURL:url]) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"NoFeatureCallSupported"];
        } else {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                } else {
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"CouldNotCallPhoneNumber"];
                }
                // return result
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }];
            return; // Avoid sending the plugin result twice
        }

        // return result for unsupported URLs
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    }];
}

@end