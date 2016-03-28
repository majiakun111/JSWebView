//
//  UIView+Controller.m
//  Component
//
//  Created by Ansel on 16/3/19.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)

- (UIViewController *)viewController
{
    UIViewController *viewController = nil;
    
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            viewController =  (UIViewController *)nextResponder;
            break;
        }
    }
    
    return viewController;
}


@end
