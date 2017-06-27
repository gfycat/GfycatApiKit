//
//  GfycatExtendedMedia.m
//  GfycatApiKit
//
//  Created by Andrii Novoselskyi on 6/7/17.
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

#import "GfycatExtendedMedia.h"
#import "GfycatModelConstants.h"
#import "NSDictionary+GfycatApiKit.h"

@interface GfycatExtendedMedia ()

@property (nonatomic, assign) NSInteger likeState;
@property (nonatomic, assign) NSInteger bookmarkState;

@end

@implementation GfycatExtendedMedia

- (instancetype)initWithInfo:(NSDictionary *)info {
    self = [super initWithInfo:info];
    if (self && GfyNotNull(info)) {
        NSMutableDictionary *gfyItem = GfyNotNull(info[kGfyItem]) ? info[kGfyItem] : info;
                
        self.likeState = [gfyItem gfy_integerValueForKey:kLikeState];
        self.bookmarkState = [gfyItem gfy_integerValueForKey:kBookmarkState];
    }
    return self;
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super initWithCoder:decoder])) {
        self.likeState = [decoder decodeIntegerForKey:kLikeState];
        self.bookmarkState = [decoder decodeIntegerForKey:kBookmarkState];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
    
    [encoder encodeInteger:self.likeState forKey:kLikeState];
    [encoder encodeInteger:self.bookmarkState forKey:kBookmarkState];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    GfycatExtendedMedia *copy = [super copyWithZone:zone];
    
    copy->_likeState = self.likeState;
    copy->_bookmarkState = self.bookmarkState;
    
    return copy;
}

@end
