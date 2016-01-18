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
//    [self replaceAllocMethod];
    [self replaceNullMethod];
}

//+ (void)replaceNull {
//    SEL selector = @selector(alloc);
//    
//    id block = ^(IMP implementation) {
//        DKNullReturnIMP methodIMP = (DKNullReturnIMP)implementation;
//        return (id)^(NSNull *nullObject, id object) {
//            return [DKNull alloc];
//            return methodIMP([DKNull class], selector, object);
//        };
//    };
    
//    [self setBlock:block forClassMethodSelector:selector];
//}


+ (void)replaceAllocMethod {
    Method originalMethod = class_getClassMethod([NSNull class], @selector(alloc));
    Method patchedMethod  = class_getClassMethod([NSNull class], @selector(patchedAlloc));
    IMP patchedImplementation = method_getImplementation(patchedMethod);
    
    class_addMethod([NSNull class], @selector(alloc), patchedImplementation, method_getTypeEncoding(patchedMethod));
    method_setImplementation(originalMethod, method_getImplementation(patchedMethod));
}

+ (void)replaceNullMethod {
    [self replaceSelector:@selector(null) withSelector:@selector(replacedNull)];
//    Method originalMethod = class_getClassMethod([NSNull class], @selector(null));
//    Method replaceMethod  = class_getClassMethod([NSNull class], @selector(replacedNull));
//    IMP replaceImplementation = method_getImplementation(replaceMethod);
//    
//    class_addMethod([NSNull class], @selector(alloc), replaceImplementation, method_getTypeEncoding(replaceMethod));
//    method_setImplementation(originalMethod, method_getImplementation(replaceMethod));
}

+ (void)replaceSelector:(SEL)selector withSelector:(SEL)patchedSelector {
    Method originalMethod = class_getClassMethod([NSNull class], selector);
    Method replaceMethod  = class_getClassMethod([NSNull class], patchedSelector);
    IMP replaceImplementation = method_getImplementation(replaceMethod);
    
    class_addMethod([NSNull class], @selector(alloc), replaceImplementation, method_getTypeEncoding(replaceMethod));
    method_setImplementation(originalMethod, method_getImplementation(replaceMethod));
}

//+ (void)setBlock:(DKBlockWithIMP)block forClassMethodSelector:(SEL)selector {
//    IMP implementaton = [self instanceMethodForSelector:selector];
//    
//    IMP blockIMP = imp_implementationWithBlock(block(implementaton));
//    
//    Method method = class_getClassMethod(self, selector);
//    class_replaceMethod(self,
//                        selector,
//                        blockIMP,
//                        method_getTypeEncoding(method));
//}

+ (id)patchedAlloc {
    return [DKNull alloc];
}

+ (NSNull *)replacedNull {
    return [DKNull null];
}

@end
