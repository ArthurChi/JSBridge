//
//  ViewController.m
//  JSBridge
//
//  Created by cjfire on 2016/12/16.
//  Copyright © 2016年 cjfire. All rights reserved.
//

#import "ViewController.h"
#import "UIWebView+JSBridge.h"
#import "WebViewBridge.h"
#import "Person.h"

@interface ViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"JSCorePractise" ofType:@".html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* req = [[NSURLRequest alloc] initWithURL:url];
    [_webView loadRequest:req];
    
    _webView.delegate = self;
    
    Person* p = [Person createWithFirstName:@"123" lastName:@"abc"];
    [_webView.bridge registObject:p alias:@"person"];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"456");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"123");
}

- (IBAction)refresh:(UIBarButtonItem *)sender {
    
    [_webView reload];
}

- (IBAction)evaluateJS:(UIBarButtonItem *)sender {
    
    NSDictionary* obj = @{@"name":@"123", @"age":@"23"};
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:0 error:nil];
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString* js = [NSString stringWithFormat:@"nativeCallback('%@', simplifyString)", str];
    [_webView stringByEvaluatingJavaScriptFromString:js];
}


@end
