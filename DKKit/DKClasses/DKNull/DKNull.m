//
//  DKNull.m
//  DKKit
//
//  Created by Daria on 14.01.16.
//  Copyright © 2016 Daria. All rights reserved.
//

#import "DKNull.h"
#import <objc/runtime.h>

static id __nullObject = nil;

@interface DKNull ()

- (void)fakeMethod;

@end

@implementation DKNull

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t predicate;
    dispatch_once( &predicate, ^{
        __nullObject = [NSNull allocWithZone:zone];
        Class objClass = object_getClass(__nullObject);
        if (![objClass isSubclassOfClass:[DKNull class]]) {
            object_setClass(__nullObject, [DKNull class]);
        }
    });
    return __nullObject;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    anInvocation.target = nil;
    [anInvocation invoke];
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector {
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (!signature) {
        signature = [[self class] instanceMethodSignatureForSelector:@selector(fakeMethod)];
    }
    return signature;
}

- (void)fakeMethod {
    
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return nil;
}

- (BOOL)isEqual:(id)object {
    return [super isEqual:object] || (!object) || ([object isEqual:[NSNull null]]);
}

- (NSUInteger)hash {
    return (NSInteger)self;
}
@end
