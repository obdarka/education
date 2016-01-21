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
        
        Class superClass = class_getSuperclass(currentClass);
        while (superClass && superClass != [NSObject class]) {
            superClass = class_getSuperclass(superClass);
        }
        
        if (superClass == [NSObject class])
            [classNames addObject:NSStringFromClass(currentClass)];
    }
    free(list);
    
    return [classNames copy];
}

@end
