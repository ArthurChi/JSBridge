//
//  NSObject+JSBridge.m
//  JSBridge
//
//  Created by cjfire on 2016/12/27.
//  Copyright © 2016年 cjfire. All rights reserved.
//

#import "NSObject+JSBridge.h"

@implementation NSObject (JSBridge)

- (void)webView:(id)unuse didCreateJavaScriptContext:(NSObject *)ctx forFrame:(id)frame {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyNameDidCreatedContext object:ctx];
}

@end
