//
//  JSWebView.m
//  JSWebView
//
//  Created by Ansel on 16/3/15.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "JavascriptInterfaceManager.h"
#import <objc/runtime.h>

@class JSCallNavtiveInterface;

@interface JavascriptInterfaceManager ()


/**
*   {
*       interfaceIdentifier : [
*                                 interface, //接口对象
*
*                                 {
*                                     methodIdentifier: method, //方法标识 => 方法名, (方法标识 为方法名的一个参数标识)
*                                     ...
*                                 }
*                              ],
*        ...
*   }
*/

@property (nonatomic, strong) NSMutableDictionary *interfacesMap;

@end

@implementation JavascriptInterfaceManager

+ (instancetype)shareInstance
{
    static JavascriptInterfaceManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[JavascriptInterfaceManager alloc] init];
        }
    });
    
    return instance;
}

- (void)addJavascriptInterface:(id)interface interfaceIdentifier:(NSString *)interfaceIdentifier
{
    NSMutableDictionary *methodsMap = [[NSMutableDictionary alloc] init];
    unsigned int methodCount = 0;
    Class cls = object_getClass(interface);
    Method * mlist = class_copyMethodList(cls, &methodCount);
    for (NSInteger index = 0; index < methodCount; index++){
        NSString *method = [NSString stringWithUTF8String:sel_getName(method_getName(mlist[index]))];
        NSArray *methodArgsIdentifier = [method componentsSeparatedByString:@":"];
        NSString *methodIdentifier = [methodArgsIdentifier firstObject]; //取方法的方法的第一个参数标识作为方法标识
        [methodsMap setObject:method forKey:methodIdentifier];
    }
    
    NSArray *interfaceInfo = @[interface, methodsMap];
    methodsMap = nil;
    
    [self.interfacesMap setObject:interfaceInfo forKey:interfaceIdentifier];
    
    free(mlist);
}

- (id)getJavascriptInterfaceWithInterfaceIdentifier:(NSString *)interfaceIdentifier
{
    return [[self.interfacesMap objectForKey:interfaceIdentifier] firstObject];
}

- (id)getJavascriptInterfaceMethodWithMethodIdentifier:(NSString *)methodIdentifier interfaceIdentifier:(NSString *)interfaceIdentifier
{
    NSDictionary *methodsMap = [[self.interfacesMap objectForKey:interfaceIdentifier] lastObject];
    return methodsMap[methodIdentifier];
}

- (NSDictionary *)getInterfacesMap
{
    return self.interfacesMap;
}

#pragma mark - 

- (NSMutableDictionary *)interfacesMap
{
    if (nil == _interfacesMap) {
        _interfacesMap = [[NSMutableDictionary alloc] init];
    }
    
    return _interfacesMap;
}

@end
