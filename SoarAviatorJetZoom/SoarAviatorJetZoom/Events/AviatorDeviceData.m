//
//  PulseDeviceMessage.m
//  SoarAviatorJetZoom
//
//  Created by SoarAviatorJetZoom on 2024/8/6.
//

#import "AviatorDeviceData.h"

@implementation AviatorDeviceData

+ (void)airForDeviceWrapper:(AviatorWebViewBaseCG *)bridge {
    
    if (NULL != bridge) {
        
        [bridge registerHandler:@"getPackageName" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
            responseCallback(bundleId);
        }];
        
        [bridge registerHandler:@"getThirdLogins" handler:^(id data, WVJBResponseCallback responseCallback) {
            responseCallback(@"{\"gg\":1,\"fb\":0}");
        }];
        
    }
}

@end
