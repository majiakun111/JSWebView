//
//  JSCallNavtiveInterface+Data.m
//  Component
//
//  Created by Ansel on 16/3/19.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "JSCallNavtiveInterface+Data.h"

@implementation JSCallNavtiveInterface (Data)

- (void)setData: (NSString*)data forKey: (NSString*)key webView:(UIWebView *)webview callback:(void(^)(NSString *status, NSString *data))callback;
{
    if (callback) {
        callback(@"1", nil);
        callback = nil;
    }
}

- (void)getData:(NSString*)key webView:(UIWebView *)webView callback:(void(^)(NSString *status, NSString *data))callback
{
    if (callback) {
        callback(@"1", @"Ansel");
        callback = nil;
    }
}

@end
