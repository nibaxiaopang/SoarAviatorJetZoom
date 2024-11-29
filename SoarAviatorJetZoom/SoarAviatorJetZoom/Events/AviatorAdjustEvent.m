//
//  PulseAdjEventConfig.m
//  SoarAviatorJetZoom
//
//  Created by SoarAviatorJetZoom on 2024/8/6.
//

#import "AviatorAdjustEvent.h"
#import <Adjust/Adjust.h>

@implementation AviatorAdjustEvent

+ (void)airForAdjustWrapper:(AviatorWebViewBaseCG *)bridge {
    
    if (NULL != bridge) {
        
        [bridge registerHandler:@"trackEvent" handler:^(id data, WVJBResponseCallback responseCallback) {
            NSString *eventName = data[@"eventName"];
            ADJEvent *event = [ADJEvent eventWithEventToken: eventName];
            [Adjust trackEvent: event];
            responseCallback(@"success");
        }];
        
        [bridge registerHandler:@"trackRevenueEvent" handler:^(id data, WVJBResponseCallback responseCallback) {
            NSString *eventName = data[@"eventName"];
            NSNumber *amount = data[@"amount"];
            NSString *currency = data[@"currency"];
            
            NSLog(@"eventName:%@ amount:%@ currency:%@",eventName, amount, currency);
            
            ADJEvent *event = [ADJEvent eventWithEventToken: eventName];
            [event setRevenue:[amount doubleValue] currency:currency];
                
            [Adjust trackEvent: event];
            responseCallback(@"success");
        }];
        
        [bridge registerHandler:@"trackEventCallbackId" handler:^(id data, WVJBResponseCallback responseCallback) {
            NSString *eventName = data[@"eventName"];
            NSString *eid = data[@"id"];

            ADJEvent *event = [ADJEvent eventWithEventToken: eventName];
            [event setCallbackId:eid];
            [Adjust trackEvent: event];
            responseCallback(@"success");
        }];
        
        [bridge registerHandler:@"trackCallbackParameterEvent" handler:^(id data, WVJBResponseCallback responseCallback) {
            NSString *eventName = data[@"eventName"];
            NSString *key = data[@"key"];
            NSString *value = @"";
            if (![data[@"value"] isKindOfClass:NSString.class]) {
                value = [data[@"value"] stringValue];
            }
                        
            ADJEvent *event = [ADJEvent eventWithEventToken: eventName];
            [event addCallbackParameter:key value:value];
            [Adjust trackEvent: event];
            responseCallback(@"success");
            
        }];
        
        [bridge registerHandler:@"trackPartnerParameterEvent" handler:^(id data, WVJBResponseCallback responseCallback) {
            NSString *eventName = data[@"eventName"];
            NSString *key = data[@"key"];
            NSString *value = data[@"value"];
                
            ADJEvent *event = [ADJEvent eventWithEventToken: eventName];
            [event addPartnerParameter:key value:value];
            [Adjust trackEvent: event];
            responseCallback(@"success");
        }];
        
        
    }
}

@end
