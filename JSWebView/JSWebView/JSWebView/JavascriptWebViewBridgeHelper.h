//
//  WebViewProxy.h
//  JSWebView
//
//  Created by Ansel on 16/3/15.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JavascriptWebViewBridgeHelperDelegate <NSObject>

- (NSString*)evaluateJavascript:(NSString*)javascriptCommand;

@end

@interface JavascriptWebViewBridgeHelper : NSObject

@property (nonatomic, weak) id <JavascriptWebViewBridgeHelperDelegate> delegate;

- (void)handleFromJSMessage:(NSString *)messageString forWebView:(UIWebView *)webView;
- (void)injectJavascriptFile;
- (BOOL)isCorrectProcotocolURL:(NSURL*)url;
- (NSString *)getJSQueryCommod;
- (NSString *)getJSCheckIsInjectCommod;

@end
