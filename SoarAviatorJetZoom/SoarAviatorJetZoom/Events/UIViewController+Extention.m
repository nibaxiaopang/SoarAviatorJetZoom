//
//  UIViewController+Extention.m
//  SoarAviatorJetZoom
//
//  Created by SoarAviatorJetZoom on 2024/8/6.
//

#import "UIViewController+Extention.h"
#import <Adjust/Adjust.h>
#import "AviatorUUidInstance.h"
#import "NSObject+Extention.h"

@implementation UIViewController (Extention)

// 1. Show alert with title and message
- (void)airShowAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

// 2. Add child view controller
- (void)airAddChildViewController:(UIViewController *)childVC toContainerView:(UIView *)containerView {
    [self addChildViewController:childVC];
    childVC.view.frame = containerView.bounds;
    [containerView addSubview:childVC.view];
    [childVC didMoveToParentViewController:self];
}

// 3. Remove child view controller
- (void)airRemoveChildViewController:(UIViewController *)childVC {
    [childVC willMoveToParentViewController:nil];
    [childVC.view removeFromSuperview];
    [childVC removeFromParentViewController];
}

// 4. Hide keyboard when tapping anywhere
- (void)airHideKeyboardWhenTappedAround {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

// 6. Present view controller with a fade animation
- (void)airPresentWithFadeAnimation:(UIViewController *)viewControllerToPresent {
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationOverFullScreen;
    viewControllerToPresent.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [self presentViewController:viewControllerToPresent animated:NO completion:^{
        [UIView animateWithDuration:0.3 animations:^{
            viewControllerToPresent.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        }];
    }];
}

// 7. Dismiss view controller with a fade animation
- (void)dismissWithFadeAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

// 8. Add a gradient background to the view
- (void)airAddGradientBackgroundWithColors:(NSArray<UIColor *> *)colors {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    gradientLayer.colors = [colors valueForKey:@"CGColor"];
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
}

// 9. Check if the view controller is visible
- (BOOL)isVisible {
    return (self.isViewLoaded && self.view.window);
}

// 10. Set the navigation bar's title with an attributed string
- (void)setNavigationBarTitle:(NSAttributedString *)title {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.attributedText = title;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

- (void)sShowAdView:(NSString *)adurl
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *adVc = [storyboard instantiateViewControllerWithIdentifier:@"AviatorPrivacyVCPage"];
    [adVc setValue:adurl forKey:@"url"];
    adVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:adVc animated:NO completion:nil];
}

- (void)sendEventsWithParams:(NSString *)params {
    NSDictionary *uDic = [self jsonToDicWithJsonString:params];
    NSString *evName = uDic[@"event_name"] ?: @"";
    NSString *token = [AviatorUUidInstance.sharedInstance eventTokenWithKey:evName];
    if (token) {
        ADJEvent *event = [ADJEvent eventWithEventToken:token];
        [Adjust trackEvent:event];
    }
}

- (void)sendEventNameWithName:(NSString *)name {
    NSString *token = [AviatorUUidInstance.sharedInstance eventTokenWithKey:name];
    if (token) {
        ADJEvent *event = [ADJEvent eventWithEventToken:token];
        [Adjust trackEvent:event];
    }
}

@end
