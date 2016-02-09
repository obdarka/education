//
//  DKNull.m
//  DKKit
//
//  Created by Daria on 14.01.16.
//  Copyright © 2016 Daria. All rights reserved.
//

#import "DKNull.h"
#import <objc/runtime.h>
#import "NSMethodSignature+IDPNilPrivate.h"

static id __nullObject = nil;

@interface DKNull ()

- (void)fakeMethod;

@end

@implementation DKNull

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t predicate;
    dispatch_once( &predicate, ^{
        __nullObject = [super allocWithZone:zone];
        Class objClass = object_getClass(__nullObject);
        if (![objClass isSubclassOfClass:[DKNull class]]) {
            object_setClass(__nullObject, [DKNull class]);
        }
    });
    return __nullObject;
}

+ (instancetype)null {
    if (!__nullObject) {
        [DKNull new];
    }
    return __nullObject;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if (invocation.methodSignature.nilForwarded) {
        invocation.target = nil;
        [invocation invoke];
    } else {
        [super forwardInvocation:invocation];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if (!signature) {
        signature = [[self class] instanceMethodSignatureForSelector:@selector(fakeMethod)];
        signature.nilForwarded = YES;
    }
    return signature;
}

- (void)fakeMethod {
    
}

- (BOOL)isEqual:(id)object {
    return [super isEqual:object] || (!object) || ([object isEqual:[NSNull null]]);
}

- (NSUInteger)hash {
//    return (NSInteger)self;
    return [(NSNull *)kCFNull hash];
}

- (BOOL)isMemberOfClass:(Class)aClass {
    return aClass == [NSNull class] || aClass == [DKNull class];
}

@end
