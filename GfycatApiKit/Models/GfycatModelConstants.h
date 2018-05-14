//
//  GfycatModelConstants.h
//  GfycatApiKit
//
//  Created by Yin on 2/8/17.
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

// GfycatModel
extern NSString *const kGfyId;
extern NSString *const kGfyItem;

// GfycatMedia
extern NSString *const kAverageColor;
extern NSString *const kCreateDate;
extern NSString *const kCaption;
extern NSString *const kDislikes;
extern NSString *const kFrameRate;
extern NSString *const kGfyName;
extern NSString *const kGfyNumber;
extern NSString *const kGifSize;
extern NSString *const kGifUrl;
extern NSString *const kGif100Url;
extern NSString *const kGif1MbUrl;
extern NSString *const kGif2MbUrl;
extern NSString *const kGif5MbUrl;
extern NSString *const kHeight;
extern NSString *const kCategories;
extern NSString *const kLikes;
extern NSString *const kMd5;
extern NSString *const kMpgSize;
extern NSString *const kMpgUrl;
extern NSString *const kMpg320Url;
extern NSString *const kMpg360Url;
extern NSString *const kMpg640Url;
extern NSString *const kMjpgUrl;
extern NSString *const kNsfw;
extern NSString *const kNumberOfFrames;
extern NSString *const kPosterUrl;
extern NSString *const kPublished;
extern NSString *const kSourceType;
extern NSString *const kSourceUrl;
extern NSString *const kTags;
extern NSString *const kThumbnail100Url;
extern NSString *const kThumbnail320Url;
extern NSString *const kThumbnail360Url;
extern NSString *const kThumbnail640Url;
extern NSString *const kTitle;
extern NSString *const kUserName;
extern NSString *const kUserDisplayName;
extern NSString *const kUserProfileImageUrl;
extern NSString *const kViews;
extern NSString *const kWebmSize;
extern NSString *const kWebmUrl;
extern NSString *const kWebpUrl;
extern NSString *const kWidth;
extern NSString *const kHasTransparency;
extern NSString *const kProjectionType;

typedef NSString *GfycatMediaProjectionType NS_EXTENSIBLE_STRING_ENUM;

extern const GfycatMediaProjectionType GfycatMediaProjectionTypeNone;
extern const GfycatMediaProjectionType GfycatMediaProjectionTypeEquirectangular;
extern const GfycatMediaProjectionType GfycatMediaProjectionTypeFacebookCube;

// GfycatExtendedMedia
extern NSString *const kLikeState;
extern NSString *const kBookmarkState;

// GfycatReferencedMedia
extern NSString *const kColor;

// GfycatCategory
extern NSString *const kGfycats;
extern NSString *const kTag;
extern NSString *const kTagText;
extern NSString *const kGfycatMedia;
extern NSString *const kGfycatCategories;
extern NSString *const kGfycatMediaCollection;

// GfycatUploadKey
extern NSString *const kGfycatUploadName;
extern NSString *const kGfycatUploadSecret;

// GfycatConfigurationObject
extern NSString *const kPriority;
extern NSString *const kHidden;

// GfycatMediaCollectionWithPaginatedInfo
extern NSString *const kPaginationInfo;

