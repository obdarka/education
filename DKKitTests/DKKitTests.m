//
//  DKKitTests.m
//  DKKitTests
//
//  Created by Daria on 14.01.16.
//  Copyright © 2016 Daria. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DKNull.h"

@interface DKKitTests : XCTestCase {
    id nullObject;
}

@end

@implementation DKKitTests

- (void)setUp {
    [super setUp];
    nullObject = [DKNull new];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_sendUnknownMessage {
    XCTAssertNoThrow([nullObject loadView]);
}

- (void)test_sendMessageWithNil {
    XCTAssertNoThrow([nullObject view]);
    XCTAssertNil([nullObject view]);
}

- (void)test_sendMessageWithPrimitive {
    XCTAssertNoThrow([nullObject count]);
    XCTAssertEqual([nullObject count], 0);
}

- (void)test_structReturnMessage {
    XCTAssertNoThrow([nullObject frame]);
    XCTAssertTrue(CGRectIsEmpty([nullObject frame]));
}

- (void)test_sendNullMethods {
    XCTAssertNoThrow([nullObject class]);
    XCTAssertNoThrow([nullObject description]);
}

- (void)test_beEqualToNSNull {
    XCTAssertNoThrow([nullObject isEqual:[NSNull null]]);
    XCTAssertTrue([nullObject isEqual:[NSNull null]]);
}

- (void)test_compareWithNil {
    XCTAssertTrue([nullObject isEqual:nil]);
}

- (void)test_compareWithSelf {
    XCTAssertTrue([nullObject isEqual:nullObject]);
}

- (void)test_compareWithOtherObject {
    XCTAssertFalse([nullObject isEqual:[NSObject new]]);
}

- (void)test_hashForTwoObjects {
    XCTAssertTrue([nullObject hash] == [[NSNull null] hash]);
}

@end
