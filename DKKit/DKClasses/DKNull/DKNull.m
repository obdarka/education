//
//  DKNull.m
//  DKKit
//
//  Created by Daria on 14.01.16.
//  Copyright © 2016 Daria. All rights reserved.
//

#import "DKNull.h"

@implementation DKNull


- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([[NSNull null] respondsToSelector:
         [anInvocation selector]])
        [anInvocation invokeWithTarget:[NSNull null]];
    else {
        anInvocation.target = nil;
        [anInvocation invoke];
    }
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (!signature) {
        signature = [DKNull instanceMethodSignatureForSelector:@selector(fakeMethod)];
    }
    return signature;
}

- (void)fakeMethod {
    
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self;
}

- (BOOL)isEqual:(id)object {
    if(!object)
        return YES;
    else if ([object isEqual:[NSNull null]])
        return YES;
    else
        return [super isEqual:object];
}

- (NSUInteger)hash {
    return [NSNull null].hash;
}
@end
