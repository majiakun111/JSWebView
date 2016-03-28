//
//  JSCallNavtiveInterface+Data.h
//  Component
//
//  Created by Ansel on 16/3/19.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "JSCallNavtiveInterface.h"

@interface JSCallNavtiveInterface (Data)

- (void)setData: (NSString*)data forKey: (NSString*)key webView:(UIWebView *)webView callback:(void(^)(NSString *status, NSString *data))callback;

- (void)getData:(NSString*)key webView:(UIWebView *)webView callback:(void(^)(NSString *status, NSString *data))callback;

@end
