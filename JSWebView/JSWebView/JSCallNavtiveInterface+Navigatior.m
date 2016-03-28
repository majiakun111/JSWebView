//
//  JSCallNavtiveInterface+Navigatior.m
//  Component
//
//  Created by Ansel on 16/3/19.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "JSCallNavtiveInterface+Navigatior.h"
#import "LoginViewController.h"
#import "UIView+ViewController.h"

#define LOGIN_URL @"app://login"

@implementation JSCallNavtiveInterface (Navigatior)

- (void)forward:(NSString *)url webView:(UIWebView *)webView callback:(void(^)(NSString *status, NSString *data))callback
{
    if ([url isEqualToString:LOGIN_URL]) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        UIViewController *viewController = [webView viewController];
        [viewController.navigationController pushViewController:loginViewController animated:YES];
    }
    
    if (callback) {
        callback(@"1", nil);
        callback = nil;
    }
}


@end
