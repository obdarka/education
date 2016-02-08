//
//  NSObjectSubclassesTests.m
//  DKKit
//
//  Created by Daria Kovalenko on 1/21/16.
//  Copyright © 2016 Daria. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+DKSubclasses.h"
#import <objc/runtime.h>

@interface DKSubclass : NSObject
@end

@implementation DKSubclass
@end

@interface NSObjectSubclassesTests : XCTestCase
@end

@implementation NSObjectSubclassesTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_withCreationSubclass {
    Class firstClass = [DKSubclass subclassWithName:@"DKFirstClass"];
    Class secondClass = [DKSubclass subclassWithName:@"DKSecondClass"];
    NSArray *subclasses = [DKSubclass subclasses];
    NSSet *subclassesSet = [NSSet setWithArray:subclasses];
    NSSet *expectedSet = [NSSet setWithArray:@[firstClass, secondClass]];
    
    XCTAssertEqualObjects(subclassesSet, expectedSet);
    expectedSet = nil;
    subclasses = nil;
    subclassesSet = nil;
    
//    objc_disposeClassPair(firstClass);
    [firstClass removeClass];
}

@end
