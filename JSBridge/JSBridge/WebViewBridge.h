//
//  WebViewBridge.h
//  JSBridge
//
//  Created by cjfire on 2016/10/31.
//  Copyright © 2016年 cjfire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

typedef void(^JSBridgeCallback)(NSString*);

@interface WebViewBridge : NSObject

@property (nonatomic, readonly, weak) UIWebView* webView;

/**
 *  webview's delegate must defined before invoke this muthod
 *
 *  @param webView webView
 *
 *  @return webview's proxy
 */
- (instancetype) initWith:(UIWebView*)webView;

- (void)registerObject:(id)obj alias:(NSString*)alias;

- (void)unregisterObjectForAlias:(NSString*) alias;
- (void)unregisterAllObjects;

- (id)evaluateScript:(NSString*)js;
- (void)evaluateScript:(NSString*)jsFuncName withDictionary:(NSDictionary*)argums callbackSelector:(SEL) aSelector;
- (void)evaluateScript:(NSString*)jsFuncName withDictionary:(NSDictionary*)argums callbackBlock:(JSBridgeCallback) callback;

@end
