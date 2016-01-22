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

@interface DKNullSubclass : DKNull
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
    NSSet *expectedSet = [NSSet setWithArray:@[[DKNull class], [DKNullSubclass class]]];
    XCTAssertEqualObjects([NSSet setWithArray:subclasses], expectedSet);
}

@end
