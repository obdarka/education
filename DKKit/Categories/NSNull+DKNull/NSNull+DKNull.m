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

static IMP originAllocIMP = nil;
static IMP originNullIMP = nil;

@implementation NSNull (DKNull)

+ (void)load {
    originAllocIMP = method_getImplementation(class_getClassMethod([NSNull class], @selector(allocWithZone:)));
    originNullIMP = method_getImplementation(class_getClassMethod([NSNull class], @selector(null)));
}

+ (void)injectDKNull {
    [self replaceAllocMethod];
    [self replaceNullMethod];
//    [self replaceAllocMethod];
//    [self replaceNullMethod];
}

+ (void)removeDKNull {
//    id nullObject = [NSNull null];
//    object_setClass(nullObject, [NSNull class]);
    [self removeAllocInject];
    [self removeNullInject];
}

+ (void)removeNullInject {
    [self replaceSelector:@selector(null) withOriginImplementation:originNullIMP];
}

+ (void)removeAllocInject {
    [self replaceSelector:@selector(allocWithZone:) withOriginImplementation:originAllocIMP];
}

+ (void)replaceSelector:(SEL)selector withOriginImplementation:(IMP)implementation {
    Method methodToReplace = class_getClassMethod([NSNull class], selector);
    class_replaceMethod([NSNull class], selector, implementation, method_getTypeEncoding(methodToReplace));
    method_setImplementation(methodToReplace, implementation);
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
