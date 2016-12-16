//
//  UIWebView+JSBridge.m
//  JSBridge
//
//  Created by cjfire on 2016/10/31.
//  Copyright © 2016年 cjfire. All rights reserved.
//

#import "UIWebView+JSBridge.h"
#import "WebViewBridge.h"
#import <objc/runtime.h>

static NSString* webViewBridge = @"webViewBridge";

@interface UIWebView()

@property (nonatomic, strong, readwrite) WebViewBridge* bridge;

@end

@implementation UIWebView (JSBridge)
@dynamic bridge;

- (void)setBridge:(WebViewBridge *)bridge {
    objc_setAssociatedObject(self, &webViewBridge, bridge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WebViewBridge*)bridge {
    return objc_getAssociatedObject(self, &webViewBridge);
}

- (void)registBridge {
    NSAssert(self.delegate != nil, @"delegate mustn't be nil");
    
    self.bridge = [[WebViewBridge alloc] initWith:self];
}

@end
