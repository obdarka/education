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

+ (NSArray *)allSubclasses {
    unsigned int outCount;
    NSMutableArray *classNames = [NSMutableArray array];
    Class *list = objc_copyClassList(&outCount);
    for (int i = 0; i < outCount; i++) {
        Class currentClass = list[i];
        
//        Class superClass = currentClass;
//        do {
//            superClass = class_getSuperclass(superClass);
//        } while (superClass && superClass != [NSObject class]);
        
//        if (superClass == [NSObject class])
//            [classNames addObject:NSStringFromClass(currentClass)];
        
        
//        Protocol *protocol = @protocol(NSObject);
//        class_conformsToProtocol(class, protocol);
//        if (class_conformsToProtocol(class, protocol)) {
//            [classNames addObject:NSStringFromClass(class)];
//        }
        NSLog(@"%@", currentClass);
    }
    return [classNames copy];
}

@end
