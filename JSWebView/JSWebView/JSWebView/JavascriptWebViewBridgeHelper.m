//
//  WebViewProxy.m
//  JSWebView
//
//  Created by Ansel on 16/3/15.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "JavascriptWebViewBridgeHelper.h"
#import "JavascriptInterfaceManager.h"
#import <objc/runtime.h>

#define URL @"mjkscheme://__MJK_QUEUE_MESSAGE__"

typedef void (^ResponseCallback)(NSString *status, id responseData);

@implementation JavascriptWebViewBridgeHelper

/**
 * js -> oc
 *   {
 *      interfaceIdentifier : '',//接口标识, 通过标识找到 Interface
 *      methodIdentifier: @"setData:", //(方法标识 为方法名的一个参数标识, setData: forKey: webView: callback:)
 *      args:[
 *        {
 *          type:'object', //参数类型
 *          value:'Ansel',//参数的值
 *        },
 *        
 *        {
 *          type = 'function',  // 当type是function时 value 是 callbackId
 *          value: 'callbackId',
 *        }
 *      ],
 *
 *   }
 *
 *   oc -> js  //oc call js  callback
 *   {
 *      responseId:'', //对应 js 的callbackId
 *      status:'',
 *      responseData : ''
 *   }
 *
 */


- (void)handleFromJSMessage:(NSString *)messageString forWebView:(UIWebView *)webView
{
    id messages = [self deserializeMessageJSON:messageString];
    
    if (![messages isKindOfClass:[NSArray class]]) {
        NSLog(@"JavascriptWebViewBridge: WARNING: Invalid %@ received: %@", [messages class], messages);
        return;
    }
    
    for (NSDictionary* message in messages) {
        if (![message isKindOfClass:[NSDictionary class]]) {
            NSLog(@"JavascriptWebViewBridge: WARNING: Invalid %@ received: %@", [message class], message);
            continue;
        }
        
        NSString *interfaceIdentifier = message[@"interfaceIdentifier"];
        id interface = [[JavascriptInterfaceManager shareInstance] getJavascriptInterfaceWithInterfaceIdentifier:interfaceIdentifier];
        NSString *methodIdentifier = message[@"methodIdentifier"];
        NSString *method = [[JavascriptInterfaceManager shareInstance] getJavascriptInterfaceMethodWithMethodIdentifier:methodIdentifier interfaceIdentifier:interfaceIdentifier];
        SEL selector = NSSelectorFromString(method);
        
        if (![interface respondsToSelector:selector]) {
            NSLog(@"JavascriptWebViewBridge: WARNING:  %@ not found", method);
            return;
        }

        // execute the interfacing method
        NSMethodSignature* sig = [[interface class] instanceMethodSignatureForSelector:selector];
        NSInvocation* invoker = [NSInvocation invocationWithMethodSignature:sig];
        invoker.selector = selector;
        invoker.target = interface;
        
        NSDictionary *webViewArg = @{@"type": @"object", @"value" : webView};
        NSMutableArray *args = [NSMutableArray arrayWithArray:message[@"args"]];
        NSDictionary *arg = [args lastObject];
        if ([arg[@"type"] isEqualToString:@"function"]) {
            [args insertObject:webViewArg atIndex:[args count] -1];
        }
        else {
            [args addObject:webViewArg];
        }
        
        ResponseCallback responseCallback = nil;
        for (NSInteger index = 0; index < [args count]; index++) {
            NSDictionary *arg = args[index];
            id value = arg[@"value"];

            NSString *type = arg[@"type"];
            if ([type isEqualToString:@"object"]) {
                [invoker setArgument:&value atIndex:(index + 2)];
            }
            else if ([type isEqualToString:@"function"]) {
                __block id callbackId = [value copy];
                if (callbackId) { //value 是callbackId
                    responseCallback = ^(NSString *status, id responseData) {
                        if (responseData == nil) {
                            responseData = @"";
                        }

                        NSDictionary* msg = @{ @"responseId": callbackId, @"status":status, @"responseData":responseData};
                        [self dispatchMessage:msg];
                        callbackId = nil;
                    };
                } else {
                    responseCallback = ^(NSString *status, id ignoreResponseData) {
                        // Do nothing
                    };
                }
                
                [invoker setArgument:&responseCallback atIndex:(index + 2)];
            }
        }
        
        [invoker invoke];
    }
}

- (void)injectJavascriptFile
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"JavascriptWebViewBridge.js" ofType:@"txt"];
    NSString *js = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self evaluateJavascript:js];
}

-(BOOL)isCorrectProcotocolURL:(NSURL*)url
{
    if([[url absoluteString] isEqualToString:URL]){
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)getJSQueryCommod
{
    return @"JavascriptWebViewBridge.fetchQueueMessage();";
}

- (NSString *)getJSCheckIsInjectCommod
{
    return @"typeof JavascriptWebViewBridge == \'object\';";
}

#pragma mark - PrivateMethod

- (void) evaluateJavascript:(NSString *)javascriptCommand
{
    [self.delegate evaluateJavascript:javascriptCommand];
}

- (void)dispatchMessage:(NSDictionary *)message {
    NSString *messageJSON = [self serializeMessage:message];

    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];
    
    NSString* javascriptCommand = [NSString stringWithFormat:@"JavascriptWebViewBridge.receiveMessageFromObjC('%@');", messageJSON];
    if ([[NSThread currentThread] isMainThread]) {
        [self evaluateJavascript:javascriptCommand];
        
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self evaluateJavascript:javascriptCommand];
        });
    }
}

- (NSString *)serializeMessage:(id)message
{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:message options:0 error:nil] encoding:NSUTF8StringEncoding];
}

- (NSArray*)deserializeMessageJSON:(NSString *)messageJSON
{
    return [NSJSONSerialization JSONObjectWithData:[messageJSON dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
}

@end
