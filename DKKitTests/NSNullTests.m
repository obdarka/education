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
#import "NSObject+IDPRuntime.h"

static IMP DKAllocWithZoneOriginIMP = nil;
static IMP DKNullOriginIMP = nil;
static IMP DKNewOriginIMP = nil;

@interface NSNull ()

+ (void)injectDKNull;
+ (void)removeDKNull;

@end

@interface NSNullTests : XCTestCase
@property (nonatomic, strong) NSData *testData;
@property (nonatomic, strong) NSDictionary *testDictionary;

- (void)prepareTestData;

- (void)replaceAllocWithZoneMethodWithCallBlock:(void (^)(void))callBlock;
- (void)replaceNullMethodWithCallBlock:(void (^)(void))callBlock;
- (void)replaceNewMethodWithCallBlock:(void (^)(void))callBlock;

- (void)replaceAllocWithOriginImplementation;
- (void)replaceNullWithOriginImplementation;
- (void)replaceWithOriginIMP:(IMP)originImplementation forSelector:(SEL)selector;

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
    NSMutableArray *selectorsCall = [NSMutableArray array];
    
    [self replaceNullMethodWithCallBlock:^{
        [selectorsCall addObject:@"null"];
    }];
    
    [self replaceAllocWithZoneMethodWithCallBlock:^{
        [selectorsCall addObject:@"allocWithZone"];
    }];
    
    [self replaceNewMethodWithCallBlock:^{
        [selectorsCall addObject:@"new"];
    }];
    
    id serializationObject = [NSJSONSerialization JSONObjectWithData:self.testData options:NSJSONReadingMutableContainers error:nil];
    
    XCTAssertEqualObjects(serializationObject, self.testDictionary);
    XCTAssertEqualObjects(selectorsCall, @[@"null"]);
    
    id nullObject = serializationObject[@"nullKey"];
    XCTAssertTrue([nullObject isMemberOfClass:[NSNull class]]);
    
    [self replaceNullWithOriginImplementation];
    [self replaceAllocWithOriginImplementation];
    [self replaceNewWithOriginImplementation];
    
}

- (void)test_dkNullInject {
    [self prepareTestData];
    [NSNull injectDKNull];
    
    id serializationObject = [NSJSONSerialization JSONObjectWithData:self.testData options:NSJSONReadingMutableContainers error:nil];
    id nullObject = serializationObject[@"nullKey"];
    XCTAssertTrue([nullObject isMemberOfClass:[NSNull class]]);
    XCTAssertTrue([nullObject isMemberOfClass:[DKNull class]]);
    
    [NSNull removeDKNull];
    
    id secondSerialization = [NSJSONSerialization JSONObjectWithData:self.testData options:NSJSONReadingMutableContainers error:nil];
    id noninjectNullObject = secondSerialization[@"nullKey"];
    XCTAssertTrue([noninjectNullObject isMemberOfClass:[NSNull class]]);
    XCTAssertFalse([noninjectNullObject isMemberOfClass:[DKNull class]]);
}

#pragma mark -
#pragma mark Methods
- (void)prepareTestData {
    NSError *error = nil;
    self.testDictionary = @{ @"nullKey" : [NSNull null]};
    self.testData = [NSJSONSerialization dataWithJSONObject:self.testDictionary options:NSJSONWritingPrettyPrinted error:&error];
}


#pragma mark -
#pragma mark Replacements
- (void)replaceAllocWithZoneMethodWithCallBlock:(void (^)(void))callBlock {
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
    DKNewOriginIMP = implementation;
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

#pragma mark -
#pragma mark Replace with origin implementations
- (void)replaceAllocWithOriginImplementation {
    [self replaceWithOriginIMP:DKAllocWithZoneOriginIMP forSelector:@selector(allocWithZone:)];
}

- (void)replaceNullWithOriginImplementation {
    [self replaceWithOriginIMP:DKNullOriginIMP forSelector:@selector(null)];
}

- (void)replaceNewWithOriginImplementation {
    [self replaceWithOriginIMP:DKNewOriginIMP forSelector:@selector(new)];
}

- (void)replaceWithOriginIMP:(IMP)originImplementation forSelector:(SEL)selector {
    id object = [NSNull class];
    Class class = object_getClass(object);
    Method method = class_getInstanceMethod(class, selector);
    class_replaceMethod(class, selector, originImplementation, method_getTypeEncoding(method));
}

@end
