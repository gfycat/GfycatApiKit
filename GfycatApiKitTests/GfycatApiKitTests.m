//
//  GfycatApiKitTests.m
//  GfycatApiKitTests
//
//  Created by Victor Pavlychko on 4/3/17.
//  Copyright 2017 Gfycat
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <XCTest/XCTest.h>
#import "NSDictionary+Gfycat.h"

@interface GfycatApiKitTests : XCTestCase

@end

@implementation GfycatApiKitTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
}

- (void)testDiconaryCategory {
    NSDictionary *dict = @{
                           @"nullStr": @"<null>",
                           @"null": [NSNull null],
                           @"str": @"strV",
                           @"numb": @5,
                           @"boolT": @YES,
                           @"boolF": @NO,
                           @"url": @"http://www.apple.com",
                           @"date": @(1497008678.741301),
                           @"array": @[@1, @2],
                           @"dict": @{@"1": @1, @"2": @2},
                           };
    
    XCTAssertNil([dict gfy_numberValueForKey:@"nullStr"]);
    XCTAssertNil([dict gfy_numberValueForKey:@"null"]);
    XCTAssertNil([dict gfy_numberValueForKey:@"str"]);
    XCTAssertNotNil([dict gfy_numberValueForKey:@"numb"]);
    
    XCTAssertNil([dict gfy_stringValueForKey:@"nullStr"]);
    XCTAssertNil([dict gfy_stringValueForKey:@"null"]);
    XCTAssertNotNil([dict gfy_stringValueForKey:@"str"]);
    XCTAssertNil([dict gfy_stringValueForKey:@"numb"]);
    
    XCTAssertEqual([dict gfy_integerValueForKey:@"nullStr"], 0);
    XCTAssertEqual([dict gfy_integerValueForKey:@"null"], 0);
    XCTAssertEqual([dict gfy_integerValueForKey:@"str"], 0);
    XCTAssertNotEqual([dict gfy_integerValueForKey:@"numb"], 0);
    
    XCTAssertNotEqual([dict gfy_integerValueForKey:@"boolT"], 0);
    XCTAssertEqual([dict gfy_integerValueForKey:@"boolF"], 0);
    XCTAssertEqual([dict gfy_integerValueForKey:@"url"], 0);
    XCTAssertNotEqual([dict gfy_integerValueForKey:@"date"], 0);
    XCTAssertEqual([dict gfy_integerValueForKey:@"array"], 0);
    XCTAssertEqual([dict gfy_integerValueForKey:@"dict"], 0);
    
    XCTAssertFalse([dict gfy_boolValueForKey:@"nullStr"]);
    XCTAssertFalse([dict gfy_boolValueForKey:@"null"]);
    XCTAssertFalse([dict gfy_boolValueForKey:@"str"]);
    XCTAssertTrue([dict gfy_boolValueForKey:@"numb"]);
    XCTAssertTrue([dict gfy_boolValueForKey:@"boolT"]);
    XCTAssertFalse([dict gfy_boolValueForKey:@"boolF"]);
    
    XCTAssertNil([dict gfy_urlValueForKey:@"nullStr"]);
    XCTAssertNil([dict gfy_urlValueForKey:@"null"]);
    XCTAssertNotNil([dict gfy_urlValueForKey:@"str"]);
    XCTAssertNil([dict gfy_urlValueForKey:@"numb"]);
    XCTAssertNotNil([dict gfy_urlValueForKey:@"url"]);
    
    XCTAssertNil([dict gfy_dateValueForKey:@"nullStr"]);
    XCTAssertNil([dict gfy_dateValueForKey:@"null"]);
    XCTAssertNil([dict gfy_dateValueForKey:@"str"]);
    XCTAssertNotNil([dict gfy_dateValueForKey:@"numb"]);
    XCTAssertNotNil([dict gfy_dateValueForKey:@"date"]);
    
    XCTAssertNil([dict gfy_arrayValueForKey:@"nullStr"]);
    XCTAssertNil([dict gfy_arrayValueForKey:@"null"]);
    XCTAssertNil([dict gfy_arrayValueForKey:@"str"]);
    XCTAssertNil([dict gfy_arrayValueForKey:@"numb"]);
    XCTAssertNotNil([dict gfy_arrayValueForKey:@"array"]);
    XCTAssertNil([dict gfy_arrayValueForKey:@"dict"]);
    
    XCTAssertNil([dict gfy_dictionaryValueForKey:@"nullStr"]);
    XCTAssertNil([dict gfy_dictionaryValueForKey:@"null"]);
    XCTAssertNil([dict gfy_dictionaryValueForKey:@"str"]);
    XCTAssertNil([dict gfy_dictionaryValueForKey:@"numb"]);
    XCTAssertNil([dict gfy_dictionaryValueForKey:@"array"]);
    XCTAssertNotNil([dict gfy_dictionaryValueForKey:@"dict"]);
}

@end
