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
#import "NSDictionary+GfycatApiKit.h"
#import "GfycatApi.h"
#import "GfycatMedia.h"
#import "GfycatCategory.h"
#import "GfycatCollection.h"

@interface GfycatApiKitTests : XCTestCase

@end

@implementation GfycatApiKitTests

- (void)setUp {
    [super setUp];

    [GfycatApi.shared setAppClientID:[[[NSProcessInfo processInfo] environment] objectForKey:@"Test_GfycatApiClientId"]
                          withSecret:[[[NSProcessInfo processInfo] environment] objectForKey:@"Test_GfycatApiClientSecret"]];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
}

- (void)testDictionaryCategory {
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

- (void)testCreateAccount {
    
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __FUNCTION__]];
    expectation.expectedFulfillmentCount = 2;
    
    NSUUID *userUUID = [NSUUID UUID];
    
    uuid_t uuidBytes;
    [userUUID getUUIDBytes:uuidBytes];
    // time-low(4bytes)"-"time-mid(2bytes)"-"time-high-and-version(2bytes, version - last 4 bits)"-"clock-seq-and-reserved(1byte, first 6 bits are less significant) clock-seq-low(1byte)"-"node(6bytes)
    // merge 8th and 9th bytes info 8th and remove 9th
    uuidBytes[8] = (uuidBytes[8] & 0xf0) | (uuidBytes[9] & 0x0f);
    unsigned char loginUUID[15];
    memcpy(loginUUID, &(uuidBytes[1]), sizeof(unsigned char) * 15);
    memcpy(loginUUID, uuidBytes, sizeof(unsigned char) * 9);
    
    // now should be 20 chars length long
    NSString *userName = [[NSData dataWithBytes:loginUUID length:sizeof(loginUUID)] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    userName = [userName stringByReplacingOccurrencesOfString:@"/" withString:@"0"];
    userName = [userName stringByReplacingOccurrencesOfString:@"+" withString:@"0"];
    userName = [userName stringByReplacingOccurrencesOfString:@"=" withString:@"0"];
    
    NSString *userPassword = userUUID.UUIDString;
    
    [GfycatApi.shared createAccountWithUsername:userName password:userPassword email:nil success:^(NSDictionary * _Nonnull serverResponse) {
        NSString *accessToken = [serverResponse gfy_stringValueForKey:@"access_token"];
        XCTAssertNotNil(accessToken);
        
        [GfycatApi.shared validateSession:^(NSDictionary * _Nonnull serverResponse) {
            XCTAssertNotNil(accessToken);
            [expectation fulfill];
        } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
            XCTAssertNil(error);
        }];
        
        [GfycatApi.shared refreshSession:^(NSDictionary * _Nonnull serverResponse) {
            XCTAssertNotNil(accessToken);
            [expectation fulfill];
        } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
            XCTAssertNil(error);
        }];
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        XCTAssertNil(error);
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        XCTAssertNil(error);
    }];
}

- (void)testGetMedia {
    
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __FUNCTION__]];
    
    [GfycatApi.shared getMedia:@"ActualSlimyGilamonster" withSuccess:^(GfycatMedia * _Nonnull media) {
        [expectation fulfill];
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        XCTAssertNil(error);
    }];
}

- (void)testGetExtendedMedia {
    
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __FUNCTION__]];
    
    [GfycatApi.shared getExtendedMedia:@"ActualSlimyGilamonster" withSuccess:^(GfycatExtendedMedia * _Nonnull media) {
        [expectation fulfill];
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        XCTAssertNil(error);
    }];
}

- (void)testGetCategories {
    
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __FUNCTION__]];
    NSInteger count = 5;
    
    [GfycatApi.shared getCategoriesCount:count withSuccess:^(GfycatCategories * _Nonnull categories, GfycatPaginationInfo * _Nullable paginationInfo, BOOL isFromCache) {
        XCTAssertTrue(categories.array.count <= count);
        [expectation fulfill];
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        XCTAssertNil(error);
    }];
}

- (void)testGetCategoryMedia {
    
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __FUNCTION__]];
    
    NSInteger count = 5;
    
    [GfycatApi.shared getCategoryMedia:@"trending" count:count withSuccess:^(GfycatMediaCollection * _Nonnull mediaCollection, GfycatPaginationInfo * _Nullable paginationInfo, BOOL isFromCache) {
        XCTAssertTrue(mediaCollection.array.count <= count);
        [expectation fulfill];
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        XCTAssertNil(error);
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        XCTAssertNil(error);
    }];
}

- (void)testGetCollections {

    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __FUNCTION__]];
    NSInteger count = 5;

    [GfycatApi.shared getUserCollections:@"dubudabu" count:count success:^(GfycatCollections * _Nonnull collections, GfycatPaginationInfo * _Nullable paginationInfo) {
        XCTAssertTrue(collections.array.count <= count);
        [expectation fulfill];
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        XCTAssertNil(error);
    }];
}

- (void)testGetCollectionMedia {

    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __FUNCTION__]];
    NSInteger count = 5;

    [GfycatApi.shared getUserCollectionMedia:@"dubudabu" folderId:@"26c83310e086ac29bcc10cfa2cf54f77" count:count withSuccess:^(GfycatMediaCollection * _Nonnull mediaCollection, GfycatPaginationInfo * _Nullable paginationInfo) {
        XCTAssertTrue(mediaCollection.array.count <= count);
        [expectation fulfill];
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        XCTAssertNil(error);
    }];
}

- (void)testGetMyCollections {

    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __FUNCTION__]];
    NSInteger count = 5;
    NSString *userName = nil;
    NSString *userPassword = nil;

    NSParameterAssert(userName);
    NSParameterAssert(userPassword);
    
    [GfycatApi.shared loginWithUsername:userName password:userPassword success:^(NSDictionary * _Nonnull serverResponse) {
        [GfycatApi.shared getCurrentUserCollectionsCount:count success:^(GfycatCollections * _Nonnull collections, GfycatPaginationInfo * _Nullable paginationInfo) {
            XCTAssertTrue(collections.array.count <= count);
            [expectation fulfill];
        } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
            XCTAssertNil(error);
            [expectation fulfill];
        }];
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        XCTAssertNil(error);
    }];

    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        XCTAssertNil(error);
    }];
}

- (void)testGetMyCollectionMedia {

    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __FUNCTION__]];
    NSInteger count = 5;
    NSString *userName = nil;
    NSString *userPassword = nil;
    NSString *collectionId = nil;
    
    NSParameterAssert(userName);
    NSParameterAssert(userPassword);
    NSParameterAssert(collectionId);

    [GfycatApi.shared loginWithUsername:userName password:userPassword success:^(NSDictionary * _Nonnull serverResponse) {
        [GfycatApi.shared getCurrentUserCollectionMedia:collectionId count:count withSuccess:^(GfycatMediaCollection * _Nonnull mediaCollection, GfycatPaginationInfo * _Nullable paginationInfo) {
            XCTAssertTrue(mediaCollection.array.count <= count);
            [expectation fulfill];
        } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
            XCTAssertNil(error);
            [expectation fulfill];
        }];
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        XCTAssertNil(error);
    }];

    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        XCTAssertNil(error);
    }];
}

- (void)testGetSearchMedia {
    
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __FUNCTION__]];
    
    NSInteger count = 5;
    
    [GfycatApi.shared searchMediaWithString:@"hello" count:count withSuccess:^(GfycatMediaCollection * _Nonnull mediaCollection, GfycatPaginationInfo * _Nullable paginationInfo) {
        XCTAssertTrue(mediaCollection.array.count <= count);
        [expectation fulfill];
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        XCTAssertNil(error);
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        XCTAssertNil(error);
    }];
}

- (void)testDownloadFile {
    
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __FUNCTION__]];
    
    [GfycatApi.shared getMedia:@"ActualSlimyGilamonster" withSuccess:^(GfycatMedia * _Nonnull media) {
        [GfycatApi.shared downloadFileWithURL:media.gfyUrl completion:^(NSURLResponse * _Nullable response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            NSLog(@"");
            XCTAssertNotNil(response);
            XCTAssertNotNil(filePath);
            XCTAssertNil(error);
            [expectation fulfill];
        }];
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        XCTAssertNil(error);
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        XCTAssertNil(error);
    }];
}

- (void)testLikeMedia {
    
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __FUNCTION__]];
    
    [GfycatApi.shared likeMedia:@"ActualSlimyGilamonster" forTag:nil withSuccess:^(NSDictionary * _Nonnull serverResponse) {
        [expectation fulfill];
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        XCTAssertNil(error);
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        XCTAssertNil(error);
    }];
}

- (void)testDislikeMedia {
    
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __FUNCTION__]];
    
    [GfycatApi.shared dislikeMedia:@"ActualSlimyGilamonster" forTag:nil withSuccess:^(NSDictionary * _Nonnull serverResponse) {
        [expectation fulfill];
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        XCTAssertNil(error);
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        XCTAssertNil(error);
    }];
}

- (void)testGetReferencedMedia {
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __FUNCTION__]];
    
    [GfycatApi.shared getReferencedMedia:[NSURL URLWithString:@"https://gfycat.com/PerfumedLateGermanshorthairedpointer"] withSuccess:^(GfycatReferencedMedia * _Nonnull media) {
        [expectation fulfill];
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        XCTAssertNil(error);
    }];
}

//- (void)testGetConfigurationObjects {
//    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __FUNCTION__]];
//
//    [GfycatApi.shared getConfigurationObjectsSuccess:^(NSArray<GfycatConfigurationObject *> * _Nonnull configurationObjects) {
//        [expectation fulfill];
//    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
//        XCTAssertNil(error);
//        [expectation fulfill];
//    }];
//
//    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
//        if (error != nil) {
//            NSLog(@"Error: %@", error.localizedDescription);
//        }
//        XCTAssertNil(error);
//    }];
//}

- (void)testGetLikedMediasCount {
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __FUNCTION__]];
    
    [GfycatApi.shared getLikedMediasCount:1 cursor:nil withSuccess:^(GfycatMediaCollection * _Nonnull mediaCollection, GfycatPaginationInfo * _Nullable paginationInfo) {
        [expectation fulfill];
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        XCTAssertNil(error);
    }];
}

- (void)testGetCreatedMediasCount {
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __FUNCTION__]];
    
    [GfycatApi.shared getCreatedMediasCount:1 cursor:nil withSuccess:^(GfycatMediaCollection * _Nonnull mediaCollection, GfycatPaginationInfo * _Nullable paginationInfo) {
        [expectation fulfill];
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        XCTAssertNil(error);
    }];
}

- (void)testReportMedia {
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __FUNCTION__]];
    
    [GfycatApi.shared reportMedia:@"ActualSlimyGilamonster" withSuccess:^(NSDictionary * _Nonnull serverResponse) {
        [expectation fulfill];
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        XCTAssertNil(error);
    }];
}

- (void)testUserProfile {
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __FUNCTION__]];
    
    [GfycatApi.shared getUserProfile:@"golbanstorage" success:^(GfycatUserProfile * _Nonnull userProfile) {
        NSLog(@"%@", userProfile);
        [expectation fulfill];
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        XCTAssertNil(error);
    }];
}

@end
