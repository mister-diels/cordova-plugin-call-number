#import <Cordova/CDVPlugin.h>
#import "CFCallNumber.h"

@implementation CFCallNumber

- (void) callNumber:(CDVInvokedUrlCommand*)command {

    __block CDVPluginResult* pluginResult = nil;
    [self.commandDelegate runInBackground:^{

        NSString* number = [command.arguments objectAtIndex:0];
        number = [number stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

        if( ! [number hasPrefix:@"tel:"]){
            number =  [NSString stringWithFormat:@"tel:%@", number];
        }

        if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:number]]) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"NoFeatureCallSupported"];
        }
        else {
            NSURL *url = [NSURL URLWithString:number];
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
               if (!success) {
                   pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"CouldNotCallPhoneNumber"];
               } else {
                   pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
               }
           }];
        }

        // return result
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    }];
}

@end