//
//  NSNullTests.m
//  DKKit
//
//  Created by Daria on 20.01.16.
//  Copyright © 2016 Daria. All rights reserved.
//

#import <XCTest/XCTest.h>
//#import "NSNull+DKNull.h"
//#import "DKNull.h"
#import "NSObject+IDPRuntime.h"

static IMP DKAllocWithZoneOriginIMP = nil;
static IMP DKNullOriginIMP = nil;

@interface NSNullTests : XCTestCase
@property (strong, nonatomic) NSData *testData;
@end

@implementation NSNullTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_callNullImplementation {
    [self prepareTestData];
    XCTestExpectation *nullExpectation = [self expectationWithDescription:@"Null called"];
    [self replaceNullMethodWithCallBlock:^{
            [nullExpectation fulfill];
    }];
    
    NSError *error = nil;
    [NSJSONSerialization JSONObjectWithData:self.testData options:NSJSONReadingMutableContainers error:&error];
    
    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError * _Nullable error) {
        [self replaceNullWithOriginImplementation];
    }];
}

- (void)test_callAllocImplementation {
    [self prepareTestData];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Alloc with zone called"];
    [self replaceAllocMethodWithCallBlock:^{
        [expectation fulfill];
    }];

    [NSNull new];
    
    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError * _Nullable error) {
        [self replaceAllocWithOriginImplementation];
    }];
}


#pragma mark - Methods
- (void)prepareTestData {
    NSError *error = nil;
    NSDictionary *dict = @{ @"nullKey" : [NSNull null]};
    self.testData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
}

- (void)replaceAllocMethodWithCallBlock:(void (^)(void))callBlock {
    SEL selector = @selector(allocWithZone:);
    id object = [NSNull class];
    
    Class class = object_getClass(object);
    if (class_isMetaClass(class)) {
        NSLog(@"Is that metaclass");
    }
    
    IMP implementation = [class instanceMethodForSelector:selector];
    DKAllocWithZoneOriginIMP = implementation;
    
    id block = ^(id object, NSZone *zone) {
        NSLog(@"alloc with zone block called");
        if (callBlock) {
            callBlock();
        }
        return ((id(*)(id, SEL, NSZone *))implementation)(object, selector, zone);
    };
    IMP blockImp = imp_implementationWithBlock(block);
    Method method = class_getInstanceMethod(class, selector);
    class_replaceMethod(class, selector, blockImp, method_getTypeEncoding(method));
}

- (void)replaceAllocWithOriginImplementation {
    [self replaceWithOriginIMP:DKAllocWithZoneOriginIMP forSelector:@selector(allocWithZone:)];
}

- (void)replaceNullWithOriginImplementation {
    [self replaceWithOriginIMP:DKNullOriginIMP forSelector:@selector(null)];
}

- (void)replaceWithOriginIMP:(IMP)originImplementation forSelector:(SEL)selector {
    id object = [NSNull class];
    Class class = object_getClass(object);
    Method method = class_getInstanceMethod(class, selector);
    class_replaceMethod(class, selector, originImplementation, method_getTypeEncoding(method));
}

- (void)replaceNullMethodWithCallBlock:(void (^)(void))callBlock {
    SEL selector = @selector(null);
    id object = [NSNull class];
    
    Class class = object_getClass(object);
    if (class_isMetaClass(class)) {
        NSLog(@"Is that metaclass");
    }
    
    IMP implementation = [class instanceMethodForSelector:selector];
    DKNullOriginIMP = implementation;
    id block = ^(id object) {
        NSLog(@"null block called");
        if (callBlock) {
            callBlock();
        }
        return ((id(*)(id, SEL))implementation)(object, selector);
    };
    IMP blockImp = imp_implementationWithBlock(block);
    Method method = class_getInstanceMethod(class, selector);
    class_replaceMethod(class, selector, blockImp, method_getTypeEncoding(method));
}

- (void)replaceNewMethodWithCallBlock:(void (^)(void))callBlock {
    SEL selector = @selector(new);
    id object = [NSNull class];
    
    Class class = object_getClass(object);
    if (class_isMetaClass(class)) {
        NSLog(@"Is that metaclass");
    }
    
    IMP implementation = [class instanceMethodForSelector:selector];
    id block = ^(id object) {
        NSLog(@"new block called");
        if (callBlock) {
            callBlock();
        }
        return ((id(*)(id, SEL))implementation)(object, selector);
    };
    IMP blockImp = imp_implementationWithBlock(block);
    Method method = class_getInstanceMethod(class, selector);
    class_replaceMethod(class, selector, blockImp, method_getTypeEncoding(method));
}

@end
