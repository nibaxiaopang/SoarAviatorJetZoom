//
//  PulseWebViewBaseConfig.h
//
//  Created by SoarAviatorJetZoom on 10/15/14.
//  Copyright (c) 2014 SoarAviatorJetZoom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AviatorWViewCGLogBase.h"
#import <WebKit/WebKit.h>

@interface AviatorWebViewBaseCG : NSObject<WKNavigationDelegate, WebViewJavascriptBridgeBaseDelegate>

+ (instancetype)briForWebView:(WKWebView*)webView;
+ (void)enableLogging;

- (void)registerHandler:(NSString*)handlerName handler:(WVJBHandler)handler;
- (void)removeHandler:(NSString*)handlerName;
- (void)callHandler:(NSString*)handlerName;
- (void)callHandler:(NSString*)handlerName data:(id)data;
- (void)callHandler:(NSString*)handlerName data:(id)data responseCallback:(WVJBResponseCallback)responseCallback;
- (void)reset;
- (void)setWebViewDelegate:(id)webViewDelegate;
- (void)disableJavscriptAlertBoxSafetyTimeout;

@end

