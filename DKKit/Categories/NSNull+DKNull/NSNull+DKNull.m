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
typedef NSNull *(*DKNullReturnIMP)(id, SEL, id);

@implementation NSNull (DKNull)

+ (void)load {

    [self replaceNull];
}

+ (void)replaceNull {
    SEL selector = @selector(null);
    
    id block = ^(IMP implementation) {
//        DKNullReturnIMP methodIMP = (DKNullReturnIMP)implementation;
        return (id)^(NSNull *nullObject, id object) {
            return [DKNull null];
//            return methodIMP([DKNull class], selector, object);
        };
    };
    
    [self setBlock:block forClassMethodSelector:selector];
}

+ (void)setBlock:(DKBlockWithIMP)block forClassMethodSelector:(SEL)selector {
    IMP implementaton = [self instanceMethodForSelector:selector];
    
    IMP blockIMP = imp_implementationWithBlock(block(implementaton));
    
    Method method = class_getClassMethod(self, selector);
    class_replaceMethod(self,
                        selector,
                        blockIMP,
                        method_getTypeEncoding(method));
}
@end
