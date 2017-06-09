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

@interface GfycatMedia : GfycatReferencedMedia <NSCopying, NSSecureCoding, NSObject>

@end

@interface GfycatMediaCollection : NSObject <NSCopying, NSSecureCoding>

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
