//
//  PulseGoogleEventTool.m
//  SoarAviatorJetZoom
//
//  Created by SoarAviatorJetZoom on 2024/8/6.
//

#import "AviatorGoogleEvTool.h"
#import <FirebaseAuth/FirebaseAuth.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <FirebaseCore/FirebaseCore.h>

@interface AviatorGoogleEvTool ()
@property (nonatomic, weak) UIViewController *goVC;
@end
@implementation AviatorGoogleEvTool

+ (AviatorGoogleEvTool *)airForFirebaseGoogleWrapper:(AviatorWebViewBaseCG *)bridge controllerFor:(UIViewController *)viewController
{
    AviatorGoogleEvTool *gp = [[AviatorGoogleEvTool alloc] init];
    gp.goVC = viewController;
    
    if (NULL != bridge) {
        
        [bridge registerHandler:@"googleLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
            NSLog(@"googleLogin");
            GIDConfiguration *config = [[GIDConfiguration alloc] initWithClientID:[FIRApp defaultApp].options.clientID];
            [GIDSignIn.sharedInstance setConfiguration:config];

            __weak __auto_type weakSelf = self;
            [GIDSignIn.sharedInstance signInWithPresentingViewController:viewController
                  completion:^(GIDSignInResult * _Nullable result, NSError * _Nullable error) {
              __auto_type strongSelf = weakSelf;
              if (strongSelf == nil) { return; }

              if (error == nil) {
                  FIRAuthCredential *credential =
                  [FIRGoogleAuthProvider credentialWithIDToken:result.user.idToken.tokenString accessToken:result.user.accessToken.tokenString];
                  
                  [FIRAuth.auth signInWithCredential:credential completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
                      if (authResult) {
                          FIRUser *user = authResult.user;
                          [user getIDTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
                              if (error) {
                                  NSLog(@"FIRUser get id token error: %@\n",error);
                              } else {
                                  NSString *userInfo =  [NSString stringWithFormat:@"{\"photoUrl\":\"%@\",\"displayName\":\"%@\",\"idToken\":\"%@\"}", user.photoURL, user.displayName, token];
                                  NSLog(@"userInfo: %@", userInfo);
                                  responseCallback(userInfo);
                              }
                          }];
                      }
                  }];
              } else {
              }
            }];

        }];
        
        [bridge registerHandler:@"firebaseLogout" handler:^(id data, WVJBResponseCallback responseCallback) {
            NSLog(@"firebaseLogout");
            NSError *signOutError;
            BOOL status = [[FIRAuth auth] signOut:&signOutError];
            if (!status) {
                NSLog(@"Error signing out: %@", signOutError);
            } else {
                NSLog(@"Successfully signed out");
            }
            responseCallback(@"success");
        }];
    }
    
    return gp;
}

@end
