//
//  GfycatMedia.m
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

#import "GfycatMedia.h"
#import "GfycatModelConstants.h"
#import "GfycatApiConstants.h"
#import "NSDictionary+Gfycat.h"

@interface GfycatMedia ()

@property (nonatomic, copy) NSString *averageColor;
@property (nonatomic) NSDate *createDate;
@property (nonatomic, copy) NSString *caption;
@property (nonatomic, assign) NSInteger dislikes;
@property (nonatomic, assign) NSInteger frameRate;
@property (nonatomic, copy) NSString *gfyName;
@property (nonatomic, assign) NSInteger gfyNumber;
@property (nonatomic, assign) NSInteger gifSize;
@property (nonatomic) NSURL *gifUrl;
@property (nonatomic) NSURL *gif100Url;
@property (nonatomic) NSURL *gif1MbUrl;
@property (nonatomic) NSURL *gif2MbUrl;
@property (nonatomic) NSURL *gif5MbUrl;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic) NSArray<NSString *> *categories;
@property (nonatomic, assign) NSInteger likes;
@property (nonatomic, copy) NSString *md5;
@property (nonatomic, assign) NSInteger mpgSize;
@property (nonatomic) NSURL *mpgUrl;
@property (nonatomic) NSURL *mpg320Url;
@property (nonatomic) NSURL *mpg640Url;
@property (nonatomic) NSURL *mjpgUrl;
@property (nonatomic, assign, getter=isNsfw) BOOL nsfw;
@property (nonatomic, assign) NSInteger numberOfFrames;
@property (nonatomic) NSURL *posterUrl;
@property (nonatomic, assign, getter=isPublished) BOOL published;
@property (nonatomic, assign) NSInteger sourceType;
@property (nonatomic) NSURL *sourceUrl;
@property (nonatomic) NSArray<NSString *> *tags;
@property (nonatomic) NSURL *thumbnail100Url;
@property (nonatomic) NSURL *thumbnail320Url;
@property (nonatomic) NSURL *thumbnail640Url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) NSInteger views;
@property (nonatomic, assign) NSInteger webmSize;
@property (nonatomic) NSURL *webmUrl;
@property (nonatomic) NSURL *webpUrl;
@property (nonatomic, assign) NSInteger width;

@end

@implementation GfycatMedia

@synthesize size = _size;

- (instancetype)initWithInfo:(NSDictionary *)info {
    self = [super initWithInfo:info];
    if (self && GfyNotNull(info)) {
        NSMutableDictionary *gfyItem = GfyNotNull(info[kGfyItem]) ? info[kGfyItem] : info;
        
        self.averageColor = [gfyItem gfy_stringValueForKey:kAverageColor];
        self.createDate = [gfyItem gfy_dateValueForKey:kCreateDate];
        self.caption = [gfyItem gfy_stringValueForKey:kCaption];
        self.dislikes = [gfyItem gfy_integerValueForKey:kDislikes];
        self.frameRate = [gfyItem gfy_integerValueForKey:kFrameRate];
        self.gfyName = [gfyItem gfy_stringValueForKey:kGfyName];
        self.gfyNumber = [gfyItem gfy_integerValueForKey:kGfyNumber];
        self.gifSize = [gfyItem gfy_integerValueForKey:kGifSize];
        self.gifUrl = [gfyItem gfy_urlValueForKey:kGifUrl];
        self.gif100Url = [gfyItem gfy_urlValueForKey:kGif100Url];
        self.gif1MbUrl = [gfyItem gfy_urlValueForKey:kGif1MbUrl];
        self.gif2MbUrl = [gfyItem gfy_urlValueForKey:kGif2MbUrl];
        self.gif5MbUrl = [gfyItem gfy_urlValueForKey:kGif5MbUrl];
        self.height = [gfyItem gfy_integerValueForKey:kHeight];
        self.categories = [gfyItem gfy_arrayValueForKey:kCategories];
        self.likes = [gfyItem gfy_integerValueForKey:kLikes];
        self.md5 = [gfyItem gfy_stringValueForKey:kMd5];
        self.mpgSize = [gfyItem gfy_integerValueForKey:kMpgSize];
        self.mpgUrl = [gfyItem gfy_urlValueForKey:kMpgUrl];
        self.mpg320Url = [gfyItem gfy_urlValueForKey:kMpg320Url];
        self.mpg640Url = [gfyItem gfy_urlValueForKey:kMpg640Url];
        self.mjpgUrl = [gfyItem gfy_urlValueForKey:kMjpgUrl];
        self.nsfw = [gfyItem gfy_boolValueForKey:kNsfw];
        self.numberOfFrames = [gfyItem gfy_integerValueForKey:kNumberOfFrames];
        self.posterUrl = [gfyItem gfy_urlValueForKey:kPosterUrl];
        self.published = [gfyItem gfy_boolValueForKey:kPublished];
        self.sourceType = [gfyItem gfy_integerValueForKey:kSourceType];
        self.sourceUrl = [gfyItem gfy_urlValueForKey:kSourceUrl];
        self.tags = [gfyItem gfy_arrayValueForKey:kTags] ?: [NSArray new];
        self.thumbnail100Url = [gfyItem gfy_urlValueForKey:kThumbnail100Url];
        self.thumbnail320Url = [gfyItem gfy_urlValueForKey:kThumbnail320Url];
        self.thumbnail640Url = [gfyItem gfy_urlValueForKey:kThumbnail640Url];
        self.title = [gfyItem gfy_stringValueForKey:kTitle];
        self.userName = [gfyItem gfy_stringValueForKey:kUserName];
        self.views = [gfyItem gfy_integerValueForKey:kViews];
        self.webmSize = [gfyItem gfy_integerValueForKey:kWebmSize];
        self.webmUrl = [gfyItem gfy_urlValueForKey:kWebmUrl];
        self.webpUrl = [gfyItem gfy_urlValueForKey:kWebpUrl];
        self.width = [gfyItem gfy_integerValueForKey:kWidth];
    }
    return self;
}

- (CGSize)size {
    if (CGSizeEqualToSize(_size, CGSizeZero)) {
        _size = CGSizeMake(self.width, self.height);
    }
    
    return _size;
}

@end

@interface GfycatMediaCollection()

@property (nonatomic) NSArray<GfycatMedia *> *array;

@end

@implementation GfycatMediaCollection

- (NSArray *)array {
    if (!_array) {
        _array = [NSArray new];
    }
    
    return _array;
}

- (instancetype)initWithArray:(NSArray<GfycatMedia *> *)array {
    if (self = [super init]) {
        self.array = [array copy];
    }
    return self;
}

- (instancetype)initWithInfo:(NSDictionary *)info {
    if (self = [super init]) {
        NSArray *gfycats = info[kGfycats];
        if (GfyNotNull(gfycats)) {
            NSMutableArray *array = [NSMutableArray new];
            for (NSDictionary *gfycat in gfycats) {
                [array addObject:[[GfycatMedia alloc] initWithInfo:gfycat]];
            }
            self.array = [array copy];
        }
    }
    return self;
}

#pragma mark - Equality

- (NSUInteger)hash {
    return self.array.hash;
}

- (BOOL)isEqual:(GfycatMediaCollection *)collection {
    if (![collection isKindOfClass:[GfycatMediaCollection class]]) {
        return NO;
    }
    return [self.array isEqual:collection.array];
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [self init])) {
        self.array = [decoder decodeObjectOfClass:[NSString class] forKey:kGfycatMediaCollection];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.array forKey:kGfycatMediaCollection];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    GfycatMediaCollection *copy = [[[self class] allocWithZone:zone] init];
    copy->_array = [self.array copy];
    return copy;
}

@end
