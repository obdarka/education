//
//  DKNull.m
//  DKKit
//
//  Created by Daria on 14.01.16.
//  Copyright © 2016 Daria. All rights reserved.
//

#import "DKNull.h"

@implementation DKNull

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSMethodSignature *methodSignature = [NSNull methodSignatureForSelector:anInvocation.selector];
    if (methodSignature) {
        [super forwardInvocation:anInvocation];
    } else {
    anInvocation.target = nil;
    [anInvocation invoke];
    }
}
+ (BOOL)resolveClassMethod:(SEL)sel {
    return [NSNull resolveClassMethod:sel];
}

+ (IMP)instanceMethodForSelector:(SEL)aSelector {
    return [NSNull instanceMethodForSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self;
}


+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return [NSNull resolveInstanceMethod:sel];
}
@end
