//
//  ViewController.m
//  JSWebView
//
//  Created by Ansel on 16/3/15.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "TestJSWebViewController.h"
#import "JavascriptWebViewBridge.h"
#import "JSCallNavtiveInterface.h"
#import "JavascriptInterfaceManager.h"

@interface TestJSWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) JavascriptWebViewBridge *bridge;

@end

@implementation TestJSWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:_webView];
    
    JSCallNavtiveInterface* interface = [[JSCallNavtiveInterface alloc] init];
    [[JavascriptInterfaceManager shareInstance] addJavascriptInterface:interface interfaceIdentifier:@"Interface"];
    _bridge = [JavascriptWebViewBridge bridgeForWebView:_webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] 																		 pathForResource:@"Test" ofType:@"html"]isDirectory:NO]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
@end
