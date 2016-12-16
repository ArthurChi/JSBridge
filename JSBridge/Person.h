//
//  Person.h
//  JSBridge
//
//  Created by cjfire on 2016/12/16.
//  Copyright © 2016年 cjfire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@class Person;
@protocol PersonJSExports <JSExport>

@property(nonatomic, copy) NSString* firstName;
@property(nonatomic, copy) NSString* lastName;
@property(nonatomic, strong) NSNumber* birthYear;

+ (Person*)createWithFirstName:(NSString*)firstName lastName:(NSString*)lastName;
- (NSString*)fullname;
- (void)setcallback:(JSValue*)callback;

@end

@interface Person : NSObject<PersonJSExports>

@property(nonatomic, copy) NSString* firstName;
@property(nonatomic, copy) NSString* lastName;
@property(nonatomic, strong) NSNumber* birthYear;

+ (Person*)createWithFirstName:(NSString*)firstName lastName:(NSString*)lastName;
- (NSString*)fullname;
- (void)setcallback:(JSValue*)callback;

@end

