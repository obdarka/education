//
//  NSObject+DKSubclasses.m
//  DKKit
//
//  Created by Daria on 20.01.16.
//  Copyright © 2016 Daria. All rights reserved.
//

#import "NSObject+DKSubclasses.h"
#import <objc/runtime.h>

@implementation NSObject (DKSubclasses)

+ (NSArray *)subclasses {
    unsigned int outCount;
    NSMutableArray *classes = [NSMutableArray array];
    Class *list = objc_copyClassList(&outCount);
    for (int i = 0; i < outCount; i++) {
        Class class = list[i];
        Class superclass = class;
        do {
            superclass = class_getSuperclass(superclass);
        } while (superclass && superclass != [NSObject class]);
        
        if (class_conformsToProtocol(superclass, @protocol(NSObject)) && class != self && [class isSubclassOfClass:self]) {
            [classes addObject:class];
        }
    }
    free(list);
    
    return [classes copy];
}

+ (Class)subclassWithName:(NSString *)name {
    Class createdClass = objc_allocateClassPair(self, [name UTF8String], 0);
    objc_registerClassPair(createdClass);
    return createdClass;
}

+ (void)removeClass {
    objc_disposeClassPair(self);
}
@end
