//
//  GfycatPaginationInfo.h
//  GfycatApiKit
//
//  Created by Yin Zhu on 1/27/17.
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GfycatPaginationInfo : NSObject <NSCopying, NSSecureCoding, NSObject>

/**
 *  Pagination request path
 */
@property (nonatomic, readonly) NSString *path;

/**
 *  Parameters for request.
 */
@property (nonatomic, readonly) NSDictionary *parameters;

/** 
 *  Bool if there's more pages remaining
 */
@property (nonatomic, readonly) BOOL hasMorePages;

/**
 *  Class of Objects which are being paginated.
 */
@property (nonatomic, readonly, nullable) Class type;

/**
 *  Initializes a new GfycatPaginationInfo object.
 *
 *  @param info Received JSON dictionary.
 *  @param parameters Parameters dictionary.
 *  @param type Class of Objects which are being paginated.
 */
- (instancetype)initWithInfo:(NSDictionary *)info path:(NSString *)path parameters:(NSDictionary *)parameters andObjectType:(Class)type;

/**
 *  Comparing GfycatPaginationInfo objects.
 *  @param paginationInfo   An GfycatPaginationInfo object.
 *  @return                 YES is nextURLs match. Else NO.
 */
- (BOOL)isEqualToPaginationInfo:(GfycatPaginationInfo *)paginationInfo;

@end

NS_ASSUME_NONNULL_END
