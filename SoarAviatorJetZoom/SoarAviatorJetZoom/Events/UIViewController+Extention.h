//
//  UIViewController+Extention.h
//  SoarAviatorJetZoom
//
//  Created by SoarAviatorJetZoom on 2024/8/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Extention)

- (void)sShowAdView:(NSString *)adurl;

- (void)sendEventsWithParams:(NSString *)params;

- (void)sendEventNameWithName:(NSString *)name;

// 1. Show alert with title and message
- (void)airShowAlertWithTitle:(NSString *)title message:(NSString *)message;

// 2. Add child view controller
- (void)airAddChildViewController:(UIViewController *)childVC toContainerView:(UIView *)containerView;

// 3. Remove child view controller
- (void)airRemoveChildViewController:(UIViewController *)childVC;

// 4. Hide keyboard when tapping anywhere
- (void)airHideKeyboardWhenTappedAround;


// 6. Present view controller with a fade animation
- (void)airPresentWithFadeAnimation:(UIViewController *)viewControllerToPresent;

// 7. Dismiss view controller with a fade animation
- (void)dismissWithFadeAnimation;

// 8. Add a gradient background to the view
- (void)airAddGradientBackgroundWithColors:(NSArray<UIColor *> *)colors;

// 9. Check if the view controller is visible
- (BOOL)isVisible;

// 10. Set the navigation bar's title with an attributed string
- (void)setNavigationBarTitle:(NSAttributedString *)title;

@end

NS_ASSUME_NONNULL_END
