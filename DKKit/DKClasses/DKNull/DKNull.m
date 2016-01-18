//
//  DKNull.m
//  DKKit
//
//  Created by Daria on 14.01.16.
//  Copyright © 2016 Daria. All rights reserved.
//

#import "DKNull.h"

static DKNull *dkNullObject;

@interface DKNull ()

+ (instancetype)null {    
    [self initNull];
    return dkNullObject;
}
- (void)fakeMethod;

@end
@implementation DKNull

+ (void)initNull {
    static dispatch_once_t predicate;
    dispatch_once( &predicate, ^{
        dkNullObject = [[DKNull alloc] init];
    } );
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    anInvocation.target = nil;
    [anInvocation invoke];
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector {
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (!signature) {
        signature = [DKNull instanceMethodSignatureForSelector:@selector(fakeMethod)];
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
