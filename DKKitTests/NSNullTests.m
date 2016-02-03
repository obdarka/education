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

@interface NSNull ()

+ (void)injectDKNull;
+ (void)removeDKNull;

@end

static IMP originNullImplementation = nil;
static IMP originAllocImplementation = nil;

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
    __block NSInteger counter = 0;
    XCTestExpectation *nullExpectation = [self expectationWithDescription:@"Null called"];
    SEL nullSel = @selector(null);
    originNullImplementation = [[NSNull class] instanceMethodForSelector:nullSel];
    [self replaceSelector:nullSel withCallBlock:^{
        if (counter == 0) {
            [nullExpectation fulfill];
        }
        counter +=1;
        NSLog(@"%ld", (long)counter);
    }];
    
    NSError *error = nil;
    [NSJSONSerialization JSONObjectWithData:self.testData options:NSJSONReadingMutableContainers error:&error];
    
    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError * _Nullable error) {
        [self removeInjectionForSelector:nullSel withOriginImplementation:originNullImplementation];
    }];
}

- (void)test_callAllocImplementation {
    [self prepareTestData];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Alloc with zone called"];
    SEL allocWithZoneSel = @selector(allocWithZone:);
    originAllocImplementation = [[NSNull class] instanceMethodForSelector:allocWithZoneSel];
    [self replaceSelector:allocWithZoneSel withCallBlock:^{
        [expectation fulfill];
    }];

    [NSNull new];
    
    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError * _Nullable error) {
        [self removeInjectionForSelector:allocWithZoneSel withOriginImplementation:originAllocImplementation];
    }];
}


#pragma mark - Methods
- (void)prepareTestData {
    NSError *error = nil;
    NSDictionary *dict = @{ @"nullKey" : [NSNull null]};
    self.testData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
}

- (void)replaceSelector:(SEL)selector withCallBlock:(void (^)(void))callBlock {
    id object = [NSNull class];
    Method method = class_getInstanceMethod(object, selector);
    Class class = object_getClass(object);
    IMP implementation = [class instanceMethodForSelector:selector];
    id block = ^(id object, NSZone *zone) {
        if (callBlock) {
            callBlock();
        }
        return ((id(*)(id, SEL, const char *types))implementation)(object, selector, method_getTypeEncoding(method));
    };
    IMP blockImp = imp_implementationWithBlock(block);
    class_replaceMethod(class, selector, blockImp, method_getTypeEncoding(method));
}

- (void)removeInjectionForSelector:(SEL)selector withOriginImplementation:(IMP)originImplementation {
    Method method = class_getInstanceMethod([NSNull class], selector);
    class_replaceMethod([NSNull class], selector, originImplementation, method_getTypeEncoding(method));
}

@end
