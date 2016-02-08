//
//  NSObjectSubclassesTests.m
//  DKKit
//
//  Created by Daria Kovalenko on 1/21/16.
//  Copyright © 2016 Daria. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+DKSubclasses.h"
#import "DKNull.h"
#import <objc/runtime.h>

@interface DKNullSubclass : NSNull
@end

@implementation DKNullSubclass
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

- (void)test_containsDKNull {
    NSArray *subclasses = [NSNull subclasses];
    NSSet *expectedSet = [NSSet setWithArray:@[[DKNullSubclass class]]];
    XCTAssertEqualObjects([NSSet setWithArray:subclasses], expectedSet);
}

- (void)test_withCreationSubclass {
    Class firstClass = [DKNullSubclass subclassWithName:@"DKFirstClass"];
    
    NSArray *subclasses = [NSNull subclasses];
    NSSet *subclassesSet = [NSSet setWithArray:subclasses];
    NSSet *expectedSet = [NSSet setWithArray:@[[DKNullSubclass class], firstClass]];
    
    XCTAssertEqualObjects(subclassesSet, expectedSet);
    expectedSet = nil;
    subclasses = nil;
    subclassesSet = nil;
    
//    objc_disposeClassPair(firstClass);
    [firstClass removeClass];
}

@end
