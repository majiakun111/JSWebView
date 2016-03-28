//
//  JSCallNavtiveInterface+Navigatior.h
//  Component
//
//  Created by Ansel on 16/3/19.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "JSCallNavtiveInterface.h"

@interface JSCallNavtiveInterface (Navigatior)

- (void)forward:(NSString *)url webView:(UIWebView *)webView callback:(void(^)(NSString *status, NSString *data))callback;

@end
