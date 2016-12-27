//
//  WebViewBridge.m
//  JSBridge
//
//  Created by cjfire on 2016/10/31.
//  Copyright © 2016年 cjfire. All rights reserved.
//

#import "WebViewBridge.h"
#import <objc/runtime.h>
#import "NSObject+JSBridge.h"

static NSString* const callbackName = @"callbackName";

@interface WebViewBridge() <UIWebViewDelegate>

@property (nonatomic, readwrite, weak) UIWebView* webView;
@property (nonatomic, weak) NSObject<UIWebViewDelegate>* target;
@property (nonatomic, weak) JSContext* jsContext;

@property (nonatomic, strong) NSMutableDictionary* shouldRegister;
@property (nonatomic, strong) NSMutableSet* registedAliases;
@property (nonatomic) SEL aSelector;
@property (nonatomic, copy) JSBridgeCallback callback;

@end

@implementation WebViewBridge

#pragma - lazy
- (NSMutableSet*)registedAliases {
    if (!_registedAliases) {
        _registedAliases = [NSMutableSet set];
    }
    
    return _registedAliases;
}

- (NSMutableDictionary*)shouldRegister {
    if (!_shouldRegister) {
        _shouldRegister = [NSMutableDictionary dictionary];
    }
    
    return _shouldRegister;
}

#pragma - life cycle
- (instancetype) initWith:(UIWebView*)webView {
    
    if (self = [super init]) {
        NSAssert(webView.delegate != nil, @"webview's delegate is nil");
        
        _target = webView.delegate;
        webView.delegate = self;
        _webView = webView;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCreateJSContext:) name:kNotifyNameDidCreatedContext object:nil];
        
        return self;
    }
    
    return nil;
}

- (void)didCreateJSContext:(NSNotification*) notification {
    _jsContext = notification.object;
    
    [self.shouldRegister enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        _jsContext[key] = obj;
    }];
    
    [self.shouldRegister removeAllObjects];
}

- (void)dealloc {
    _aSelector = nil;
    _callback = nil;
    _jsContext = nil;
}

#pragma - runtime

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return _target;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    
    if (aSelector == @selector(webViewDidStartLoad:)) {
        return YES;
    }
    
    unsigned methodCount = 0;
    unsigned selfMethodCount = 0;
    
    Method* methods = class_copyMethodList([_target class], &methodCount);
    Method* selfMethods = class_copyMethodList([_target class], &selfMethodCount);
    
    for (int index = 0; index < methodCount; index ++) {
        
        Method method = methods[index];
        SEL methodSelector = method_getName(method);
        
        if (methodSelector == aSelector) {
            return YES;
        }
    }
    
    for (int index = 0; index < selfMethodCount; index ++) {
        
        Method method = selfMethods[index];
        SEL methodSelector = method_getName(method);
        
        if (methodSelector == aSelector) {
            return YES;
        }
    }
    
    return NO;
}

#pragma public API

- (void)registerObject:(id)obj alias:(NSString*)alias {
    NSAssert(![self.registedAliases containsObject:alias], @"this alias has used, please change to other name");
    
    self.shouldRegister[alias] = obj;
    [_registedAliases addObject:alias];
}

- (id)evaluateScript:(NSString*)js {
    return [_jsContext evaluateScript:js];
}

- (void)evaluateScript:(NSString*)jsFuncName withDictionary:(NSDictionary*)argums callbackSelector:(SEL) aSelector {
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"please invocate this method in main thread");
    
    _aSelector = aSelector;
    
    [self exeJSFuncName:jsFuncName argums:argums];
}

- (void)evaluateScript:(NSString*)jsFuncName withDictionary:(NSDictionary*)argums callbackBlock:(JSBridgeCallback) callback {
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"please invocate this method in main thread");
    
    _callback = callback;
    
    [self exeJSFuncName:jsFuncName argums:argums];
}

- (void)exeJSFuncName:(NSString*)jsFuncName argums:(NSDictionary*)argums {
    NSMutableString* bridgeObjJSON = [[NSMutableString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:argums options:0 error:nil] encoding:NSUTF8StringEncoding];
    
    [bridgeObjJSON replaceOccurrencesOfString:@";" withString:@"," options:0 range:NSMakeRange(0, bridgeObjJSON.length)];
    
    NSString* tmpJs = [NSString stringWithFormat:@"%@('%@', %@)", jsFuncName, bridgeObjJSON, callbackName];
    [_jsContext evaluateScript:tmpJs];
}

- (void)unregisterObjectForAlias:(NSString*) alias {
    [_jsContext setObject:nil forKeyedSubscript:alias];
}

- (void)unregisterAllObjects {
    for (NSString* alias in _registedAliases) {
        [_jsContext setObject:nil forKeyedSubscript:alias];
    }
}

#pragma - private API

- (void)registCallback {
    
    __weak typeof(self) weakSelf = self;
    _jsContext[callbackName] = ^(NSString* input) {
        NSMutableString *mutableString = [input mutableCopy];
        CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformStripCombiningMarks, NO);
        
        __strong typeof(self)strongSelf = weakSelf;
        
        if (strongSelf.callback) {
            strongSelf.callback(mutableString);
            strongSelf.callback = nil;
        } else if (strongSelf.aSelector && [strongSelf.target respondsToSelector:strongSelf.aSelector]) {
            NSMethodSignature* methodSign = [[strongSelf.target class] instanceMethodSignatureForSelector:strongSelf.aSelector];
            NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:methodSign];
            [invocation setSelector:strongSelf.aSelector];
            [invocation setTarget:strongSelf.target];
            [invocation setArgument:&mutableString atIndex:2];
            [invocation invoke];
            strongSelf.aSelector = nil;
        }
    };
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (_webView == webView) {
        
        [self registCallback];
        
        _jsContext.exceptionHandler = ^(JSContext* jsContext, JSValue* jsValue) {
            NSLog(@"there are something wrong in js, the detail is %@", jsValue);
        };
        
        if ([_target respondsToSelector:@selector(webViewDidStartLoad:)]) {
            [_target webViewDidStartLoad:webView];
        }
    }
}

@end
