//
//  Person.m
//  JSBridge
//
//  Created by cjfire on 2016/12/16.
//  Copyright © 2016年 cjfire. All rights reserved.
//

#import "Person.h"

@implementation Person

+ (Person*)createWithFirstName:(NSString*)firstName lastName:(NSString*)lastName {
    
    Person* p = [[Person alloc] init];
    p.firstName = firstName;
    p.lastName = lastName;
    
    return p;
}

- (NSString*)fullname {
    return [NSString stringWithFormat:@"%@, %@", _firstName, _lastName];
}

- (void)setcallback:(JSValue*)callback {
    
    NSString* str = [callback toString];
    
    [callback.context evaluateScript:[NSString stringWithFormat:@"%@('this is message')", str]];
}

@end

