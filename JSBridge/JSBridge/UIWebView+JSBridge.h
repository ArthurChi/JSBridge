//
//  UIWebView+JSBridge.h
//  JSBridge
//
//  Created by cjfire on 2016/10/31.
//  Copyright © 2016年 cjfire. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WebViewBridge;

@interface UIWebView (JSBridge)

@property (nonatomic, strong, readonly) WebViewBridge* bridge;

@end
