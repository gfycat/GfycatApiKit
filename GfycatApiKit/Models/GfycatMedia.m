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

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super initWithCoder:decoder])) {
        self.averageColor = [decoder decodeObjectOfClass:[NSString class] forKey:kAverageColor];
        self.createDate = [decoder decodeObjectOfClass:[NSString class] forKey:kCreateDate];
        self.caption = [decoder decodeObjectOfClass:[NSString class] forKey:kCaption];
        self.dislikes = [decoder decodeIntegerForKey:kDislikes];
        self.frameRate = [decoder decodeIntegerForKey:kFrameRate];
        self.gfyName = [decoder decodeObjectOfClass:[NSString class] forKey:kGfyName];
        self.gfyNumber = [decoder decodeIntegerForKey:kGfyNumber];
        self.gifSize =  [decoder decodeIntegerForKey:kGifSize];
        self.gifUrl = [decoder decodeObjectOfClass:[NSURL class] forKey:kGifUrl];
        self.gif100Url = [decoder decodeObjectOfClass:[NSURL class] forKey:kGif100Url];
        self.gif1MbUrl = [decoder decodeObjectOfClass:[NSURL class] forKey:kGif1MbUrl];
        self.gif2MbUrl = [decoder decodeObjectOfClass:[NSURL class] forKey:kGif2MbUrl];
        self.gif5MbUrl = [decoder decodeObjectOfClass:[NSURL class] forKey:kGif5MbUrl];
        self.height = [decoder decodeIntegerForKey:kHeight];
        self.categories = [[decoder decodeObjectOfClass:[NSArray class] forKey:kCategories] copy];
        self.likes = [decoder decodeIntegerForKey:kFrameRate];
        self.md5 = [decoder decodeObjectOfClass:[NSString class] forKey:kMd5];
        self.mpgSize = [decoder decodeIntegerForKey:kFrameRate];
        self.mpgUrl = [decoder decodeObjectOfClass:[NSURL class] forKey:kMpgUrl];
        self.mpg320Url = [decoder decodeObjectOfClass:[NSURL class] forKey:kMpg320Url];
        self.mpg640Url = [decoder decodeObjectOfClass:[NSURL class] forKey:kMpg640Url];
        self.mjpgUrl = [decoder decodeObjectOfClass:[NSURL class] forKey:kMjpgUrl];
        self.nsfw = [decoder decodeBoolForKey:kNsfw];
        self.numberOfFrames = [decoder decodeIntegerForKey:kNumberOfFrames];
        self.posterUrl = [decoder decodeObjectOfClass:[NSURL class] forKey:kPosterUrl];
        self.published = [decoder decodeBoolForKey:kPublished];
        self.sourceType = [decoder decodeIntegerForKey:kSourceType];
        self.sourceUrl = [decoder decodeObjectOfClass:[NSURL class] forKey:kSourceUrl];
        self.tags = [[decoder decodeObjectOfClass:[NSArray class] forKey:kTags] copy];
        self.thumbnail100Url = [decoder decodeObjectOfClass:[NSURL class] forKey:kThumbnail100Url];
        self.thumbnail320Url = [decoder decodeObjectOfClass:[NSURL class] forKey:kThumbnail320Url];
        self.thumbnail640Url = [decoder decodeObjectOfClass:[NSURL class] forKey:kThumbnail640Url];
        self.title = [decoder decodeObjectOfClass:[NSString class] forKey:kTitle];
        self.userName = [decoder decodeObjectOfClass:[NSString class] forKey:kUserName];
        self.views = [decoder decodeIntegerForKey:kViews];
        self.webmSize = [decoder decodeIntegerForKey:kWebmSize];
        self.webmUrl = [decoder decodeObjectOfClass:[NSURL class] forKey:kWebmUrl];
        self.webpUrl = [decoder decodeObjectOfClass:[NSURL class] forKey:kWebpUrl];
        self.width = [decoder decodeIntegerForKey:kWidth];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:self.averageColor forKey:kAverageColor];
    [encoder encodeObject:self.createDate forKey:kCreateDate];
    [encoder encodeObject:self.caption forKey:kCaption];
    [encoder encodeInteger:self.dislikes forKey:kDislikes];
    [encoder encodeInteger:self.frameRate forKey:kFrameRate];
    [encoder encodeObject:self.gfyName forKey:kGfyName];
    [encoder encodeInteger:self.gfyNumber forKey:kGfyNumber];
    [encoder encodeInteger:self.gifSize forKey:kGifSize];
    [encoder encodeObject:self.gifUrl forKey:kGifUrl];
    [encoder encodeObject:self.gif100Url forKey:kGif100Url];
    [encoder encodeObject:self.gif1MbUrl forKey:kGif1MbUrl];
    [encoder encodeObject:self.gif2MbUrl forKey:kGif2MbUrl];
    [encoder encodeObject:self.gif5MbUrl forKey:kGif5MbUrl];
    [encoder encodeInteger:self.height forKey:kHeight];
    [encoder encodeObject:self.categories forKey:kCategories];
    [encoder encodeInteger:self.likes forKey:kLikes];
    [encoder encodeObject:self.md5 forKey:kMd5];
    [encoder encodeInteger:self.mpgSize forKey:kMpgSize];
    [encoder encodeObject:self.mpgUrl forKey:kMpgUrl];
    [encoder encodeObject:self.mpg320Url forKey:kMpg320Url];
    [encoder encodeObject:self.mpg640Url forKey:kMpg640Url];
    [encoder encodeObject:self.mjpgUrl forKey:kMjpgUrl];
    [encoder encodeBool:self.nsfw forKey:kNsfw];
    [encoder encodeInteger:self.numberOfFrames forKey:kNumberOfFrames];
    [encoder encodeObject:self.posterUrl forKey:kPosterUrl];
    [encoder encodeBool:self.published forKey:kPublished];
    [encoder encodeInteger:self.sourceType forKey:kSourceType];
    [encoder encodeObject:self.sourceUrl forKey:kSourceUrl];
    [encoder encodeObject:self.tags forKey:kTags];
    [encoder encodeObject:self.thumbnail100Url forKey:kThumbnail100Url];
    [encoder encodeObject:self.thumbnail320Url forKey:kThumbnail320Url];
    [encoder encodeObject:self.thumbnail640Url forKey:kThumbnail640Url];
    [encoder encodeObject:self.title forKey:kTitle];
    [encoder encodeObject:self.userName forKey:kUserName];
    [encoder encodeInteger:self.views forKey:kViews];
    [encoder encodeInteger:self.webmSize forKey:kWebmSize];
    [encoder encodeObject:self.webmUrl forKey:kWebmUrl];
    [encoder encodeObject:self.webpUrl forKey:kWebpUrl];
    [encoder encodeInteger:self.width forKey:kWidth];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    GfycatMedia *copy = [super copyWithZone:zone];
    
    copy->_averageColor = [self.averageColor copy];
    copy->_createDate = [self.createDate copy];
    copy->_caption = [self.caption copy];
    copy->_dislikes = self.dislikes;
    copy->_frameRate = self.frameRate;
    copy->_gfyName = [self.gfyName copy];
    copy->_gfyNumber = self.gfyNumber;
    copy->_gifSize = self.gifSize;
    copy->_gifUrl = [self.gifUrl copy];
    copy->_gif100Url = [self.gif100Url copy];
    copy->_gif1MbUrl = [self.gif1MbUrl copy];
    copy->_gif2MbUrl = [self.gif2MbUrl copy];
    copy->_gif5MbUrl = [self.gif5MbUrl copy];
    copy->_height = self.height;
    copy->_categories = [self.categories copy];
    copy->_likes = self.likes;
    copy->_md5 = [self.md5 copy];
    copy->_mpgSize = self.mpgSize;
    copy->_mpgUrl = [self.mpgUrl copy];
    copy->_mpg320Url = [self.mpg320Url copy];
    copy->_mpg640Url = [self.mpg640Url copy];
    copy->_mjpgUrl = [self.mjpgUrl copy];
    copy->_nsfw = self.nsfw;
    copy->_numberOfFrames = self.numberOfFrames;
    copy->_posterUrl = [self.posterUrl copy];
    copy->_published = self.published;
    copy->_sourceType = self.sourceType;
    copy->_sourceUrl = [self.sourceUrl copy];
    copy->_tags = [self.tags copy];
    copy->_thumbnail100Url = [self.thumbnail100Url copy];
    copy->_thumbnail320Url = [self.thumbnail320Url copy];
    copy->_thumbnail640Url = [self.thumbnail640Url copy];
    copy->_title = [self.title copy];
    copy->_userName = [self.userName copy];
    copy->_views = self.views;
    copy->_webmSize = self.webmSize;
    copy->_webmUrl = [self.webmUrl copy];
    copy->_webpUrl = [self.webpUrl copy];
    copy->_width = self.width;

    return copy;
}

- (NSURL *)webpUrl {
    if (_webpUrl != nil) {
        return _webpUrl;
    } else {
        //NSLog(@"WARNING: WebP URL Missing!"); // TODO - Remove once assured every API endpoint returns the webp url
        return self.gfyName.length ? [NSURL URLWithString:[NSString stringWithFormat:@"http://thumbs.gfycat.com/%@.webp", self.gfyName]] : nil;
    }
}

- (NSURL *)gfyUrl {
    return self.gfyName.length ? [NSURL URLWithString:[NSString stringWithFormat:@"https://gfycat.com/gifs/detail/%@", self.gfyName]] : nil;
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
