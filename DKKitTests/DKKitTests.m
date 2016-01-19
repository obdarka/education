	//
//  DKKitTests.m
//  DKKitTests
//
//  Created by Daria on 14.01.16.
//  Copyright © 2016 Daria. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DKNull.h"
@interface DKKitTests : XCTestCase

@property (strong, nonatomic) id nullObject;

@end

@implementation DKKitTests

- (void)setUp {
    [super setUp];
    self.nullObject = [NSNull null];
//    self.nullObject = [DKNull new];
//    NSError *error = nil;
//    NSDictionary *dict = @{ @"someKey" : @"stringVal", @"nullKey" : [NSNull null]};
//    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
//    id jsonObj = [NSJSONSerialization JSONObjectWithData:postData options:NSJSONReadingMutableContainers error:&error];
//    NSLog(@"%@", jsonObj);
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_sendUnknownMessage {
    XCTAssertNoThrow([self.nullObject loadView]);
}

- (void)test_sendMessageWithNil {
    XCTAssertNoThrow([self.nullObject view]);
    XCTAssertNil([self.nullObject view]);
}

- (void)test_sendMessageWithPrimitive {
    XCTAssertNoThrow([self.nullObject count]);
    XCTAssertEqual([self.nullObject count], 0);
}

- (void)test_structReturnMessage {
    XCTAssertNoThrow([self.nullObject frame]);
    XCTAssertTrue(CGRectIsEmpty([self.nullObject frame]));
}

- (void)test_sendNullMethods {
    XCTAssertNoThrow([self.nullObject class]);
    XCTAssertNoThrow([self.nullObject description]);
}

- (void)test_beEqualToNSNull {
    XCTAssertNoThrow([self.nullObject isEqual:[NSNull null]]);
    XCTAssertTrue([self.nullObject isEqual:[NSNull null]]);
}

- (void)test_compareWithNil {
    XCTAssertTrue([self.nullObject isEqual:nil]);
}

- (void)test_compareWithSelf {
    XCTAssertTrue([self.nullObject isEqual:self.nullObject]);
}

- (void)test_compareWithOtherObject {
    XCTAssertFalse([self.nullObject isEqual:[NSObject new]]);
}

- (void)test_hashForTwoObjects {
    XCTAssertTrue([self.nullObject hash] == [[NSNull null] hash]);
}

@end
