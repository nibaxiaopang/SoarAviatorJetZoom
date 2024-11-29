//
//  AviatorPrivacyVCPage.m
//  SoarAviatorJetZoom
//
//  Created by SoarAviatorJetZoom on 2024/11/29.
//

#import "AviatorPrivacyVCPage.h"
#import <WebKit/WebKit.h>
#import "AviatorUUidInstance.h"
#import "NSObject+Extention.h"
#import "AviatorGoogleEvTool.h"
#import "AviatorAdjustEvent.h"
#import "AviatorDeviceData.h"
#import "UIViewController+Extention.h"

@interface AviatorPrivacyVCPage ()<WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, strong) AviatorWebViewBaseCG *WCon;
@property (nonatomic, strong) AviatorGoogleEvTool *eventWrap;
@property (nonatomic, strong) NSArray *adsArr;
@end

@implementation AviatorPrivacyVCPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.adsArr = [NSUserDefaults.standardUserDefaults valueForKey:@"adsArr"];
    
    self.activityIndicatorView.hidesWhenStopped = YES;
    
    if (self.url.length > 0) {
        self.backBtn.hidden = YES;
        self.title = @"";
        self.navigationController.navigationBar.tintColor = [UIColor systemBlueColor];
        UIImage *image = [UIImage systemImageNamed:@"xmark"];
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    
    [self initSubViews];
    [self startInitRequest];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.webView.frame = self.view.bounds;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

#pragma mark - action
- (void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - init
- (void)initSubViews {
    if (AviatorUUidInstance.sharedInstance.type == StrikeUUidTypeN) {
        [AviatorWebViewBaseCG enableLogging];
        self.WCon = [AviatorWebViewBaseCG briForWebView:self.webView];
        [self.WCon setWebViewDelegate:self];
        [AviatorDeviceData airForDeviceWrapper:self.WCon];
        [AviatorAdjustEvent airForAdjustWrapper:self.WCon];
        self.eventWrap = [AviatorGoogleEvTool airForFirebaseGoogleWrapper:self.WCon controllerFor:self];
    } else if (AviatorUUidInstance.sharedInstance.type == StrikeUUidTypeW) {
    } else {
        NSString *AppShellVer = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSString *deviceModel = [UIDevice currentDevice].model;
        NSString *sysVersion = [[UIDevice currentDevice].systemVersion stringByReplacingOccurrencesOfString:@"." withString:@"_"];
        NSString *modelName = [UIDevice currentDevice].model;
        NSString *uuid = [AviatorUUidInstance.sharedInstance airGetUUID] ?: @"";
        self.webView.customUserAgent = [NSString stringWithFormat:@"Mozilla/5.0 (%@; CPU iPhone OS %@ like Mac OS X) AppleWebKit(KHTML, like Gecko) Mobile AppShellVer:%@ Chrome/41.0.2228.0 Safari/7534.48.3 model:%@ UUID:%@", deviceModel, sysVersion, AppShellVer, modelName, uuid];
    }
    
    [self.view addSubview:self.webView];
    [self.view sendSubviewToBack:self.bgView];
    [self.view bringSubviewToFront:self.activityIndicatorView];
    [self.view bringSubviewToFront:self.backBtn];
}

- (WKWebView *)webView
{
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        if (self.adsArr.count>0) {
            if (AviatorUUidInstance.sharedInstance.type == StrikeUUidTypeN) {
                configuration.applicationNameForUserAgent = self.adsArr[0];
            } else if (AviatorUUidInstance.sharedInstance.type == StrikeUUidTypeW) {
                [configuration.userContentController addScriptMessageHandler:self name:self.adsArr[1]];
            } else {
                [configuration.userContentController addScriptMessageHandler:self name:self.adsArr[2]];
                [configuration.userContentController addScriptMessageHandler:self name:self.adsArr[3]];
            }
        }
        
        _webView = [[WKWebView alloc] initWithFrame:UIScreen.mainScreen.bounds configuration:configuration];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.alpha = 0;
        _webView.backgroundColor = UIColor.blackColor;
        _webView.scrollView.backgroundColor = UIColor.blackColor;
        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    }
    return _webView;
}

- (void)startInitRequest {
    NSString *urlString = self.url ? : @"https://www.termsfeed.com/live/5d04491e-54f2-4b1b-8638-c8c438607d29";
    NSURL *url = [NSURL URLWithString:urlString];
    if (url) {
        [self.activityIndicatorView startAnimating];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.webView.alpha = 1;
        [self.activityIndicatorView stopAnimating];
    });
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.webView.alpha = 1;
        [self.activityIndicatorView stopAnimating];
    });
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if (self.adsArr == nil) {
        return;
    }
    if ([message.name isEqualToString:self.adsArr[1]] && [message.body isKindOfClass:[NSString class]]) {
        NSDictionary *dic = [self jsonToDicWithJsonString:(NSString *)message.body];
        NSString *evName = dic[@"funcName"] ?: @"";
        NSString *evParams = dic[@"params"] ?: @"";
        if ([evName isEqualToString:self.adsArr[4]]) {
            NSDictionary *uDic = [self jsonToDicWithJsonString:evParams];
            NSString *urlStr = uDic[@"url"] ?: @"";
            NSURL *url = [NSURL URLWithString:urlStr];
            if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }
        } else if ([evName isEqualToString:self.adsArr[5]]) {
            [self sendEventsWithParams:evParams];
        }
    } else if ([message.name isEqualToString:self.adsArr[2]]) {
        NSLog(@"%@", message.body);
        if ([message.body isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)message.body;
            NSString *evName = dic[@"eventName"] ?: @"";
            [self sendEventNameWithName:evName];
        }
    } else if ([message.name isEqualToString:self.adsArr[3]]) {
        NSLog(@"%@", message.body);
        if ([message.body isKindOfClass:[NSDictionary class]]) {
            [self updateWebViewWithDic:(NSDictionary *)message.body];
        }
    }
}

- (void)updateWebViewWithDic:(NSDictionary *)dic {
    NSInteger type = [dic[@"type"] integerValue];
    NSString *urlStr = dic[@"url"] ?: @"";
    if (type == 1) {
        NSURL *url = [NSURL URLWithString:urlStr];
        if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    } else if (type == 2) {
        AviatorPrivacyVCPage *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AviatorPrivacyVCPage"];
        vc.url = urlStr;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - WKUIDelegate
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame) {
        NSURL *url = navigationAction.request.URL;
        if (url) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }
    return nil;
}

@end
