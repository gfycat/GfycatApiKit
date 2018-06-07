//
//  GfycatMedia.h
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
#import <UIKit/UIKit.h>
#import "GfycatReferencedMedia.h"
#import "GfycatPaginationInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface GfycatMedia : GfycatReferencedMedia <NSCopying, NSSecureCoding, NSObject>

/**
 *  Date of creation of the Media.
 */
@property (nonatomic, readonly) NSDate *createDate;

/**
 *  Number of dislikes on the Media
 */
@property (nonatomic, readonly) NSInteger dislikes;

/**
 *  Original framerate of the Media
 */
@property (nonatomic, readonly) NSInteger frameRate;

/**
 *  Serial number of the Media
 */
@property (nonatomic, readonly) NSInteger gfyNumber;

/**
 *  Categories of the Media
 */
@property (nonatomic, readonly) NSArray<NSString *> *categories;

/**
 *  Number of likes on the Media
 */
@property (nonatomic, readonly) NSInteger likes;

/**
 *  MD5 checksum of the Media
 */
@property (nonatomic, copy, readonly) NSString *md5;

/**
 *  If the Media is NSFW
 */
@property (nonatomic, readonly, getter=isNsfw) BOOL nsfw;

/**
 *  Original total number of frames of the Media
 */
@property (nonatomic, readonly) NSInteger numberOfFrames;

/**
 *  If the Media is published
 */
@property (nonatomic, readonly, getter=isPublished) BOOL published;

/**
 *  Username of the creator of the Media
 */
@property (nonatomic, copy, readonly) NSString *userName;

/**
 *  Display name of the creator of the Media
 */
@property (nonatomic, copy, readonly, nullable) NSString *userDisplayName;

/**
 *  Profile image of the creator of the Media
 */
@property (nonatomic, copy, readonly, nullable) NSURL *userProfileImageUrl;

/**
 *  Number of views of the Media
 */
@property (nonatomic, readonly) NSInteger views;

/**
 *  Media was sourced from GIF or Video  // TODO - make enum.  1 = video 8 = GIF
 */
@property (nonatomic, readonly) NSInteger sourceType;

/**
 *  Source URL of the Media
 */
@property (nonatomic, copy, readonly) NSURL *sourceUrl;

/**
 *  Size in bytes of the original GIF representation of the Media
 */
@property (nonatomic, readonly) NSInteger gifSize;

/**
 *  Size in bytes of the original MP4 representation of the Media
 */
@property (nonatomic, readonly) NSInteger mpgSize;

/**
 *  Size in bytes of the original WEBM representation of the Media
 */
@property (nonatomic, readonly) NSInteger webmSize;

@end

@interface GfycatMediaCollection : NSObject <NSCopying, NSSecureCoding>

/**
 *  Cursor id to get next portion.
 */
@property (nonatomic, readonly) NSString *cursor;

/**
 *  An array of GfycatMedia objects.
 */
@property (nonatomic, readonly) NSArray<GfycatMedia *> *array;

/**
 *  Wraps existing Media array
 *  @param array Media array
 */
- (instancetype)initWithArray:(NSArray<GfycatMedia *> *)array;

/**
 *  Initializes a new instance.
 *  @param info JSON dictionary
 */
- (instancetype)initWithInfo:(NSDictionary *)info;

@end

@interface GfycatMediaCollectionWithPaginatedInfo: GfycatMediaCollection <NSCopying, NSSecureCoding>

@property (nonatomic, copy, nullable) GfycatPaginationInfo *paginationInfo;

@end

NS_ASSUME_NONNULL_END
