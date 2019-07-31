//
//  GfycatCollection.h
//  GfycatApiKit
//
//  Created by Gfycat on 12/16/18.
//  Copyright 2018 Gfycat
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

@interface GfycatCollection : NSObject <NSCopying, NSSecureCoding>

/**
 *  Title of the Collection.
 */
@property (nonatomic, readonly, copy) NSString *title;

/**
 *  Folder ID of the Collection
 */
@property (nonatomic, readonly, copy) NSString *folderId;

/**
 *  Representative media of the Collection
 */
@property (nonatomic, readonly, nullable) GfycatMedia *media;

/**
 *  Initializes a new instance.
 *  @param info JSON dictionary.
 */
- (instancetype)initWithInfo:(NSDictionary *)info;

/**
 *  Comparing Gfycat collection objects.
 *  @param collection a collection object.
 *  @return YES if title and representative media match. Else NO.
 */
- (BOOL)isEqualToCollection:(nullable GfycatCollection *)collection;

@end

@interface GfycatCollections : NSObject <NSCopying, NSSecureCoding>

/**
 *  An array of GfycatCollection objects.
 */
@property (nonatomic, readonly) NSArray<GfycatCollection *> *array;

/**
 *  Initializes a new instance.
 *  @array Array of GfycatCollection objects.
 */
- (instancetype)initWithArray:(NSArray<GfycatCollection *> *)array;

/**
 *  Initializes a new instance.
 *  @param info JSON dictionary.
 */
- (instancetype)initWithInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
