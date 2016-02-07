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

static IMP DKNullOriginAllocIMP = nil;
static IMP DKNullOriginNullIMP = nil;

@implementation NSNull (DKNull)

+ (void)load {
    DKNullOriginAllocIMP = method_getImplementation(class_getClassMethod([NSNull class], @selector(allocWithZone:)));
    DKNullOriginNullIMP = method_getImplementation(class_getClassMethod([NSNull class], @selector(null)));
}

+ (void)injectDKNull {
    [self replaceNullMethod];
}

+ (void)removeDKNull {
    [self removeAllocInject];
    [self removeNullInject];
}

+ (void)removeNullInject {
    [self replaceWithOriginIMP:DKNullOriginNullIMP forSelector:@selector(null)];
}

+ (void)removeAllocInject {
     [self replaceWithOriginIMP:DKNullOriginAllocIMP forSelector:@selector(allocWithZone:)];
}

+ (void)replaceWithOriginIMP:(IMP)originImplementation forSelector:(SEL)selector {
    id object = [NSNull class];
    Class class = object_getClass(object);
    Method method = class_getInstanceMethod(class, selector);
    class_replaceMethod(class, selector, originImplementation, method_getTypeEncoding(method));
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
    
    class_replaceMethod([NSNull class], selector, replaceImplementation, method_getTypeEncoding(replaceMethod));
    method_setImplementation(originalMethod, replaceImplementation);
}

@end
