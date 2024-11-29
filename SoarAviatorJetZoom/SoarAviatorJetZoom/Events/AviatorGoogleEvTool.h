//
//  PulseGoogleEventTool.h
//  SoarAviatorJetZoom
//
//  Created by SoarAviatorJetZoom on 2024/8/6.
//

#import <Foundation/Foundation.h>
#import "AviatorWebViewBaseCG.h"

NS_ASSUME_NONNULL_BEGIN

@interface AviatorGoogleEvTool : NSObject

+ (AviatorGoogleEvTool *)airForFirebaseGoogleWrapper:(AviatorWebViewBaseCG *)bridge controllerFor:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
