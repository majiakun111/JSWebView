//
//  JavascriptWebViewBridge.h
//  JSWebView
//
//  Created by Ansel on 16/3/15.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JavascriptWebViewBridge : NSObject <UIWebViewDelegate>

+ (instancetype)bridgeForWebView:(UIWebView *)webView;
+ (instancetype)bridgeForWebView:(UIWebView *)webView webViewDelegate:(id <UIWebViewDelegate>)webViewDelegate;

@end
