//
//  GfycatCategory.h
//  GfycatApiKit
//
//  Created by Gfycat on 2/9/17.
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
#import "GfycatMedia.h"

NS_ASSUME_NONNULL_BEGIN

@interface GfycatCategory : NSObject <NSCopying, NSSecureCoding>

/**
 *  Title of the Category.
 */
@property (nonatomic, readonly, copy) NSString *title;

/**
 *  Localized Title of the Category.
 */
@property (nonatomic, readonly, copy) NSString *localizedTitle;

/**
 *  Representative media of the Category
 */
@property (nonatomic, readonly, nullable) GfycatMedia *media;

/**
 *  Initializes a new instance.
 *  @param info JSON dictionary.
 */
- (instancetype)initWithInfo:(NSDictionary *)info;

/**
 *  Comparing Gfycat category objects.
 *  @param category a category object.
 *  @return YES if title and representative media match. Else NO.
 */
- (BOOL)isEqualToCategory:(nullable GfycatCategory *)category;

@end

@interface GfycatCategories : NSObject <NSCopying, NSSecureCoding>

/**
 *  An array of GfycatCategory objects.
 */
@property (nonatomic, readonly) NSArray<GfycatCategory *> *array;

/**
 *  Initializes a new instance.
 *  @array Array of GfycatCategory objects.
 */
- (instancetype)initWithArray:(NSArray<GfycatCategory *> *)array;

/**
 *  Initializes a new instance.
 *  @param info JSON dictionary.
 */
- (instancetype)initWithInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
