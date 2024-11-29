//
//  PulseAdjEventConfig.h
//  SoarAviatorJetZoom
//
//  Created by SoarAviatorJetZoom on 2024/8/6.
//

#import <Foundation/Foundation.h>
#import "AviatorWebViewBaseCG.h"

NS_ASSUME_NONNULL_BEGIN

@interface AviatorAdjustEvent : NSObject
+ (void)airForAdjustWrapper:(AviatorWebViewBaseCG *)bridge;
@end

NS_ASSUME_NONNULL_END
