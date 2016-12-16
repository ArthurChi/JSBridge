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
    
    [_webView registBridge];
    
    Person* p = [Person createWithFirstName:@"123" lastName:@"abc"];
    [_webView.bridge registObject:p alias:@"abc"];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"456");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"123");
}

@end
