//
//  GfycatModel.h
//  GfycatApiKit
//
//  Created by Yin Zhu on 1/23/17.
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

@interface GfycatModel : NSObject <NSCopying, NSSecureCoding, NSObject>

/**
 *  The unique identifier for each model object.
 */
@property (atomic, readonly, copy) NSString *gfyId;

/**
 *  Initializes a new instance.
 *  @param info JSON dictionary
 */
- (instancetype)initWithInfo:(NSDictionary *)info;

/**
 *  Initializes a new instance.
 *  @param gfyId unique identifier for model object
 */
- (instancetype)initWithGfyId:(NSString *)gfyId;

/**
 *  Comparing Gfycat model objects.
 *  @param model A model object.
 *  @return YES is Ids match. Else NO.
 */
- (BOOL)isEqualToModel:(nullable GfycatModel *)model;

@end

NS_ASSUME_NONNULL_END
