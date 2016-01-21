//
//  NSNullTests.m
//  DKKit
//
//  Created by Daria on 20.01.16.
//  Copyright © 2016 Daria. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSNull+DKNull.h"
#import "DKNull.h"
#import "NSObject+DKSubclasses.h"

@interface NSNullTests : XCTestCase

@end

@implementation NSNullTests

- (void)setUp {
    [super setUp];
    NSArray *subclasses = [NSObject allSubclasses];
    NSLog(@"%@", subclasses);
    [NSNull injectDKNull];
}

- (void)tearDown {
    [super tearDown];
    [NSNull removeDKNull];
}

- (void)prepareDataWithTestBlock:(void(^)(id nullObject))testBlock {
    NSError *error = nil;
    NSDictionary *dict = @{ @"nullKey" : [NSNull null]};
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    id jsonObj = [NSJSONSerialization JSONObjectWithData:postData options:NSJSONReadingMutableContainers error:&error];
    if (testBlock) {
        testBlock(jsonObj[@"nullKey"]);
    }
}

- (void)test_withoutInject {
    [NSNull removeDKNull];
    [self prepareDataWithTestBlock:^(id nullObject) {
        XCTAssertTrue([nullObject isMemberOfClass:[NSNull class]]);
    }];
}

- (void)test_inject {
    [NSNull injectDKNull];
    [self prepareDataWithTestBlock:^(id nullObject) {
        XCTAssertTrue([nullObject isMemberOfClass:[DKNull class]]);
    }];
    [NSNull removeDKNull];
}

@end
