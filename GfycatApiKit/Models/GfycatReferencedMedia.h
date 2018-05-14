//
//  GfycatReferencedMedia.h
//  GfycatApiKit
//
//  Created by Voytenko Oleksiy on 6/8/17.
//  Copyright © 2017 Gfycat. All rights reserved.
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

#import "GfycatModel.h"
#import "GfycatModelConstants.h"
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface GfycatReferencedMedia : GfycatModel <NSCopying, NSSecureCoding, NSObject>

/**
 *  Name of the Media
 */
@property (nonatomic, copy, readonly) NSString *gfyName;

/**
 *  The average color value of the Media in HEX format.  e.g. "#010202"
 */
@property (nonatomic, copy, readonly, nullable) NSString *averageColor;

/**
 *  Size, in pixels of the original media
 */
@property (nonatomic, readonly) CGSize size;

/**
 *  URL of Gfycat Media
 */
@property (nonatomic, copy, readonly) NSURL *gfyUrl;

/**
 *  URL of original GIF representation of the Media
 */
@property (nonatomic, copy, readonly) NSURL *gifUrl;

/**
 *  URL of max 100 pixels wide GIF representation of the Media
 */
@property (nonatomic, copy, readonly) NSURL *gif100Url;

/**
 *  URL of max 1MB file GIF representation of the Media
 */
@property (nonatomic, copy, readonly) NSURL *gif1MbUrl;

/**
 *  URL of max 2MB file GIF representation of the Media
 */
@property (nonatomic, copy, readonly) NSURL *gif2MbUrl;

/**
 *  URL of max 5MB file GIF representation of the Media
 */
@property (nonatomic, copy, readonly) NSURL *gif5MbUrl;

/**
 *  URL of original MP4 representation of the Media
 */
@property (nonatomic, copy, readonly) NSURL *mpgUrl;

/**
 *  URL of 320 max pixel wide MP4 representation of the Media
 */
@property (nonatomic, copy, readonly) NSURL *mpg320Url;

/**
 *  URL of 640 max pixel wide MP4 representation of the Media
 */
@property (nonatomic, copy, readonly) NSURL *mpg640Url;

/**
 *  URL of MJPG representation of the Media
 */
@property (nonatomic, copy, readonly) NSURL *mjpgUrl;

/**
 *  URL of JPG representation of the Media
 */
@property (nonatomic, copy, readonly) NSURL *posterUrl;

/**
 *  URL of 100 max pixel wide JPG representation of the Media
 */
@property (nonatomic, copy, readonly) NSURL *thumbnail100Url;

/**
 *  URL of 320 max pixel wide JPG representation of the Media
 */
@property (nonatomic, copy, readonly) NSURL *thumbnail320Url;

/**
 *  URL of 640 max pixel wide JPG representation of the Media
 */
@property (nonatomic, copy, readonly) NSURL *thumbnail640Url;

/**
 *  URL of original WEBM representation of the Media
 */
@property (nonatomic, copy, readonly) NSURL *webmUrl;

/**
 *  URL of original WEBP representation of the Media
 */
@property (nonatomic, copy, readonly) NSURL *webpUrl;

@property (nonatomic, copy, readonly) NSURL *largeWebPUrl;

/**
 *  Title of the Media
 */
@property (nonatomic, copy, readonly) NSString *title;

/**
 *  Caption written by creator of the Media
 */
@property (nonatomic, copy, readonly) NSString *caption;

/**
 *  If this media has transparent pixels
 */
@property (nonatomic, assign, readonly) BOOL hasTransparency;

@property (nonatomic, copy, readonly) GfycatMediaProjectionType projectionType;

@property (nonatomic, assign, readonly) BOOL hasSpatialContent;

/**
 *  Tags on the Media
 */
@property (nonatomic, strong) NSArray<NSString *> *tags;

- (nullable instancetype)initWithMessageURL:(NSURL *)messageURL;

- (instancetype)initWithName:(NSString *)gfyName size:(CGSize)size;

- (instancetype)initWithName:(NSString *)gfyName size:(CGSize)size averageColor:(NSString *)averageColor;

@end

NS_ASSUME_NONNULL_END
