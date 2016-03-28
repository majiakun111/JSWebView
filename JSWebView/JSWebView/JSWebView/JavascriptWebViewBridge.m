//
//  JavascriptWebViewBridge.m
//  JSWebView
//
//  Created by Ansel on 16/3/15.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "JavascriptWebViewBridge.h"
#import "JavascriptWebViewBridgeHelper.h"

@interface JavascriptWebViewBridge () <JavascriptWebViewBridgeHelperDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, weak) id <UIWebViewDelegate> webViewDelegate;

@property (nonatomic, strong) JavascriptWebViewBridgeHelper *helper;

@end

@implementation JavascriptWebViewBridge

+ (instancetype)bridgeForWebView:(UIWebView *)webView
{
    return [self bridgeForWebView:webView webViewDelegate:nil];
}

+ (instancetype)bridgeForWebView:(UIWebView *)webView webViewDelegate:(id <UIWebViewDelegate>)webViewDelegate
{
    JavascriptWebViewBridge *bridge = [[JavascriptWebViewBridge alloc] init];
    
    [bridge setUpBridgeWithWebView:webView webViewDelegate:webViewDelegate];
    
    return bridge;
}

#pragma mark - PrivateMethod

- (void)setUpBridgeWithWebView:(UIWebView *)webView webViewDelegate:(id <UIWebViewDelegate>)webViewDelegate
{
    _webView = webView;
    _webView.delegate = self;
    _webViewDelegate = webViewDelegate;
    
    _helper = [[JavascriptWebViewBridgeHelper alloc] init];
    _helper.delegate = self;
}

#pragma mark --  JavascriptWebViewBridgeHelperDelegate

- (NSString*)evaluateJavascript:(NSString*)javascriptCommand
{
    return [self.webView stringByEvaluatingJavaScriptFromString:javascriptCommand];
}

#pragma mark -- UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    
    if ([_helper isCorrectProcotocolURL:url]) {
        NSString *messageString = [self evaluateJavascript:[_helper getJSQueryCommod]];
        [_helper handleFromJSMessage:messageString forWebView:webView];
        return NO;
    } else if (self.webViewDelegate && [self.webViewDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [self.webViewDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    } else {
        return YES;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (![[self evaluateJavascript:[_helper getJSCheckIsInjectCommod]] isEqualToString:@"true"]) {
        [_helper injectJavascriptFile];
    }
    
    if (self.webViewDelegate && [self.webViewDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.webViewDelegate webViewDidFinishLoad:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.webViewDelegate && [self.webViewDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.webViewDelegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (self.webViewDelegate && [self.webViewDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.webViewDelegate webView:webView didFailLoadWithError:error];
    }
}

@end
