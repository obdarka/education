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
    NSArray *classNames = [NSObject allSubclasses];
    XCTAssertTrue([classNames containsObject:NSStringFromClass([DKNull class])]);
}


@end
