//
//  JSWebView.h
//  JSWebView
//
//  Created by Ansel on 16/3/15.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JavascriptInterfaceManager : NSObject

+ (instancetype)shareInstance;

- (void)addJavascriptInterface:(id)interface interfaceIdentifier:(NSString *)interfaceIdentifier;

- (id)getJavascriptInterfaceWithInterfaceIdentifier:(NSString *)interfaceIdentifier;

- (id)getJavascriptInterfaceMethodWithMethodIdentifier:(NSString *)methodIdentifier interfaceIdentifier:(NSString *)interfaceIdentifier;

- (NSDictionary *)getInterfacesMap;

@end
