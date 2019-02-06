//
//  GfycatUserProfile.h
//  GfycatApiKit
//
//  Created by Victor Pavlychko on 7/20/18.
//  Copyright © 2018 Gfycat. All rights reserved.
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

@interface GfycatUserProfile : NSObject <NSCopying, NSSecureCoding, NSObject>

/**
 *  A unique identifier for the user.
 */
@property (nonatomic, readonly) NSString *userid;

/**
 *  The user’s username on Gfycat.
 */
@property (nonatomic, readonly) NSString *username;

/**
 *  The user’s profile description.
 */
@property (nonatomic, readonly) NSString *descr;

/**
 *  The user’s profile link.
 */
@property (nonatomic, readonly) NSString *profileUrl;

/**
 *  The user’s name on Gfycat.
 */
@property (nonatomic, readonly) NSString *name;

/**
 *  The number of user’s gfy views on Gfycat.
 */
@property (nonatomic, readonly) NSInteger views;

/**
 *  The user’s email verification status.
 */
@property (nonatomic, readonly) BOOL emailVerified;

/**
 *  The URL to the user’s profile on Gfycat
 */
@property (nonatomic, readonly) NSString *url;

/**
 *  The unix timestamp of the date the user created their account
 */
@property (nonatomic, readonly) NSDate *createDate;

/**
 *  The URL to the user’s avatar on Gfycat
 */
@property (nonatomic, readonly) NSString *profileImageUrl;

/**
 *  The account’s verified status.
 */
@property (nonatomic, readonly) BOOL verified;

/**
 *  The number of user’s followers.
 */
@property (nonatomic, readonly) NSInteger followers;

/**
 *  The number of users this user follows.
 */
@property (nonatomic, readonly) NSInteger following;

/**
 *  Initializes a new instance.
 *  @param info JSON dictionary
 */
- (instancetype)initWithInfo:(NSDictionary *)info;

/**
 *  Comparing Gfycat model objects.
 *  @param model A model object.
 *  @return YES is Ids match. Else NO.
 */
- (BOOL)isEqualToUserProfile:(nullable GfycatUserProfile *)model;

@end

NS_ASSUME_NONNULL_END
