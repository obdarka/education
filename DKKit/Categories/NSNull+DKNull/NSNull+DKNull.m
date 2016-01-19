//
//  NSNull+DKNull.m
//  DKKit
//
//  Created by Daria on 18.01.16.
//  Copyright © 2016 Daria. All rights reserved.
//

#import "NSNull+DKNull.h"
#import "DKNull.h"
#import <objc/runtime.h>

typedef id(^DKBlockWithIMP)(IMP implementation);
typedef id(*DKNullReturnIMP)(id, SEL, id);

@implementation NSNull (DKNull)

+ (void)load {
    [self replaceAllocMethod];
    [self replaceNullMethod];
}

+ (void)replaceAllocMethod {
    [self replaceSelector:@selector(allocWithZone:) withClass:[DKNull class]];
}

+ (void)replaceNullMethod {
    [self replaceSelector:@selector(null) withClass:[DKNull class]];
}

+ (void)replaceSelector:(SEL)selector withClass:(Class)class {
    Method originalMethod = class_getClassMethod([NSNull class], selector);
    Method replaceMethod  = class_getClassMethod(class, selector);
    IMP replaceImplementation = method_getImplementation(replaceMethod);
    
    class_addMethod([NSNull class], @selector(alloc), replaceImplementation, method_getTypeEncoding(replaceMethod));
    method_setImplementation(originalMethod, method_getImplementation(replaceMethod));
}

@end
