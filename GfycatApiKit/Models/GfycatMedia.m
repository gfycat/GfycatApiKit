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
#import "NSDictionary+GfycatApiKit.h"

@interface GfycatMedia ()

@property (nonatomic, readwrite) NSDate *createDate;
@property (nonatomic, assign, readwrite) NSInteger dislikes;
@property (nonatomic, assign, readwrite) NSInteger frameRate;
@property (nonatomic, assign, readwrite) NSInteger gfyNumber;
@property (nonatomic, readwrite) NSArray<NSString *> *categories;
@property (nonatomic, assign, readwrite) NSInteger likes;
@property (nonatomic, copy, readwrite) NSString *md5;
@property (nonatomic, assign, getter=isNsfw, readwrite) BOOL nsfw;
@property (nonatomic, assign, readwrite) NSInteger numberOfFrames;
@property (nonatomic, assign, getter=isPublished, readwrite) BOOL published;
@property (nonatomic, copy, readwrite) NSString *userName;
@property (nonatomic, copy, readwrite) NSString *userDisplayName;
@property (nonatomic, copy, readwrite) NSURL *userProfileImageUrl;
@property (nonatomic, assign, readwrite) NSInteger views;

@property (nonatomic, assign, readwrite) NSInteger sourceType;
@property (nonatomic, copy, readwrite) NSURL *sourceUrl;

@property (nonatomic, assign, readwrite) NSInteger gifSize;
@property (nonatomic, assign, readwrite) NSInteger mpgSize;
@property (nonatomic, assign, readwrite) NSInteger webmSize;

@property (nonatomic, copy, readwrite) NSURL *gifUrl;
@property (nonatomic, copy, readwrite) NSURL *gif100Url;
@property (nonatomic, copy, readwrite) NSURL *gif1MbUrl;
@property (nonatomic, copy, readwrite) NSURL *gif2MbUrl;
@property (nonatomic, copy, readwrite) NSURL *gif5MbUrl;
@property (nonatomic, copy, readwrite) NSURL *mpgUrl;
@property (nonatomic, copy, readwrite) NSURL *mpg320Url;
@property (nonatomic, copy, readwrite) NSURL *mpg640Url;
@property (nonatomic, copy, readwrite) NSURL *mjpgUrl;
@property (nonatomic, copy, readwrite) NSURL *posterUrl;
@property (nonatomic, copy, readwrite) NSURL *thumbnail100Url;
@property (nonatomic, copy, readwrite) NSURL *thumbnail320Url;
@property (nonatomic, copy, readwrite) NSURL *thumbnail640Url;
@property (nonatomic, copy, readwrite) NSURL *webmUrl;
@property (nonatomic, copy, readwrite) NSURL *webpUrl;
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *caption;
@property (nonatomic, assign, readwrite) BOOL hasTransparency;

@end

@implementation GfycatMedia

@synthesize gfyUrl = _gfyUrl;
@synthesize gifUrl = _gifUrl;
@synthesize gif100Url = _gif100Url;
@synthesize gif1MbUrl = _gif1MbUrl;
@synthesize gif2MbUrl = _gif2MbUrl;
@synthesize gif5MbUrl = _gif5MbUrl;

@synthesize mpgUrl = _mpgUrl;
@synthesize mpg320Url = _mpg320Url;
@synthesize mpg640Url = _mpg640Url;
@synthesize mjpgUrl = _mjpgUrl;

@synthesize posterUrl = _posterUrl;
@synthesize thumbnail100Url = _thumbnail100Url;
@synthesize thumbnail320Url = _thumbnail320Url;
@synthesize thumbnail640Url = _thumbnail640Url;

@synthesize webmUrl = _webmUrl;
@synthesize webpUrl = _webpUrl;

@synthesize title = _title;
@synthesize caption = _caption;

@synthesize hasTransparency = _hasTransparency;


- (instancetype)initWithInfo:(NSDictionary *)info {
    self = [super initWithInfo:info];
    if (self && GfyNotNull(info)) {
        NSMutableDictionary *gfyItem = GfyNotNull(info[kGfyItem]) ? info[kGfyItem] : info;

        self.createDate = [gfyItem gfy_dateValueForKey:kCreateDate];
        self.caption = [gfyItem gfy_stringValueForKey:kCaption];
        self.dislikes = [gfyItem gfy_integerValueForKey:kDislikes];
        self.frameRate = [gfyItem gfy_integerValueForKey:kFrameRate];
        self.gfyNumber = [gfyItem gfy_integerValueForKey:kGfyNumber];
        self.categories = [gfyItem gfy_arrayValueForKey:kCategories];
        self.likes = [gfyItem gfy_integerValueForKey:kLikes];
        self.md5 = [gfyItem gfy_stringValueForKey:kMd5];
        self.nsfw = [gfyItem gfy_boolValueForKey:kNsfw];
        self.numberOfFrames = [gfyItem gfy_integerValueForKey:kNumberOfFrames];
        self.published = [gfyItem gfy_boolValueForKey:kPublished];
        self.tags = [gfyItem gfy_arrayValueForKey:kTags] ?: [NSArray new];
        self.title = [gfyItem gfy_stringValueForKey:kTitle];
        self.userName = [gfyItem gfy_stringValueForKey:kUserName];
        self.userDisplayName = [gfyItem gfy_stringValueForKey:kUserDisplayName];
        self.userProfileImageUrl = [gfyItem gfy_urlValueForKey:kUserProfileImageUrl];
        self.views = [gfyItem gfy_integerValueForKey:kViews];

        self.sourceType = [gfyItem gfy_integerValueForKey:kSourceType];
        self.sourceUrl = [gfyItem gfy_urlValueForKey:kSourceUrl];

        self.gifSize = [gfyItem gfy_integerValueForKey:kGifSize];
        self.mpgSize = [gfyItem gfy_integerValueForKey:kMpgSize];
        self.webmSize = [gfyItem gfy_integerValueForKey:kWebmSize];

        self.gifUrl = [gfyItem gfy_urlValueForKey:kGifUrl];
        self.gif100Url = [gfyItem gfy_urlValueForKey:kGif100Url];
        self.gif1MbUrl = [gfyItem gfy_urlValueForKey:kGif1MbUrl];
        self.gif2MbUrl = [gfyItem gfy_urlValueForKey:kGif2MbUrl];
        self.gif5MbUrl = [gfyItem gfy_urlValueForKey:kGif5MbUrl];

        self.mpgUrl = [gfyItem gfy_urlValueForKey:kMpgUrl];
        self.mpg320Url = [gfyItem gfy_urlValueForKey:kMpg320Url];
        self.mpg640Url = [gfyItem gfy_urlValueForKey:kMpg640Url];
        self.mjpgUrl = [gfyItem gfy_urlValueForKey:kMjpgUrl];

        self.posterUrl = [gfyItem gfy_urlValueForKey:kPosterUrl];
        self.thumbnail100Url = [gfyItem gfy_urlValueForKey:kThumbnail100Url];
        self.thumbnail320Url = [gfyItem gfy_urlValueForKey:kThumbnail320Url];
        self.thumbnail640Url = [gfyItem gfy_urlValueForKey:kThumbnail640Url];

        self.webmUrl = [gfyItem gfy_urlValueForKey:kWebmUrl];
        self.webpUrl = [gfyItem gfy_urlValueForKey:kWebpUrl];

        self.hasTransparency = [gfyItem gfy_boolValueForKey:kHasTransparency];
    }
    return self;
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super initWithCoder:decoder])) {
        
        self.createDate = [decoder decodeObjectOfClass:[NSString class] forKey:kCreateDate];
        self.caption = [decoder decodeObjectOfClass:[NSString class] forKey:kCaption];
        self.dislikes = [decoder decodeIntegerForKey:kDislikes];
        self.frameRate = [decoder decodeIntegerForKey:kFrameRate];
        self.gfyNumber = [decoder decodeIntegerForKey:kGfyNumber];
        self.categories = [[decoder decodeObjectOfClass:[NSArray class] forKey:kCategories] copy];
        self.likes = [decoder decodeIntegerForKey:kFrameRate];
        self.md5 = [decoder decodeObjectOfClass:[NSString class] forKey:kMd5];
        self.nsfw = [decoder decodeBoolForKey:kNsfw];
        self.numberOfFrames = [decoder decodeIntegerForKey:kNumberOfFrames];
        self.published = [decoder decodeBoolForKey:kPublished];
        self.tags = [[decoder decodeObjectOfClass:[NSArray class] forKey:kTags] copy];
        self.title = [decoder decodeObjectOfClass:[NSString class] forKey:kTitle];
        self.userName = [decoder decodeObjectOfClass:[NSString class] forKey:kUserName];
        self.userDisplayName = [decoder decodeObjectOfClass:[NSString class] forKey:kUserDisplayName];
        self.userProfileImageUrl = [decoder decodeObjectOfClass:[NSString class] forKey:kUserProfileImageUrl];
        self.views = [decoder decodeIntegerForKey:kViews];
        
        self.sourceType = [decoder decodeIntegerForKey:kSourceType];
        self.sourceUrl = [decoder decodeObjectOfClass:[NSURL class] forKey:kSourceUrl];

        self.mpgSize = [decoder decodeIntegerForKey:kFrameRate];
        self.webmSize = [decoder decodeIntegerForKey:kWebmSize];
        self.gifSize =  [decoder decodeIntegerForKey:kGifSize];
        
        self.gifUrl = [decoder decodeObjectOfClass:[NSURL class] forKey:kGifUrl];
        self.gif100Url = [decoder decodeObjectOfClass:[NSURL class] forKey:kGif100Url];
        self.gif1MbUrl = [decoder decodeObjectOfClass:[NSURL class] forKey:kGif1MbUrl];
        self.gif2MbUrl = [decoder decodeObjectOfClass:[NSURL class] forKey:kGif2MbUrl];
        self.gif5MbUrl = [decoder decodeObjectOfClass:[NSURL class] forKey:kGif5MbUrl];
        
        self.mpgUrl = [decoder decodeObjectOfClass:[NSURL class] forKey:kMpgUrl];
        self.mpg320Url = [decoder decodeObjectOfClass:[NSURL class] forKey:kMpg320Url];
        self.mpg640Url = [decoder decodeObjectOfClass:[NSURL class] forKey:kMpg640Url];
        self.mjpgUrl = [decoder decodeObjectOfClass:[NSURL class] forKey:kMjpgUrl];
        
        self.posterUrl = [decoder decodeObjectOfClass:[NSURL class] forKey:kPosterUrl];
        self.thumbnail100Url = [decoder decodeObjectOfClass:[NSURL class] forKey:kThumbnail100Url];
        self.thumbnail320Url = [decoder decodeObjectOfClass:[NSURL class] forKey:kThumbnail320Url];
        self.thumbnail640Url = [decoder decodeObjectOfClass:[NSURL class] forKey:kThumbnail640Url];
        
        self.webmUrl = [decoder decodeObjectOfClass:[NSURL class] forKey:kWebmUrl];
        self.webpUrl = [decoder decodeObjectOfClass:[NSURL class] forKey:kWebpUrl];

        self.hasTransparency = [decoder decodeBoolForKey:kHasTransparency];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
 
    [encoder encodeObject:self.createDate forKey:kCreateDate];
    [encoder encodeObject:self.caption forKey:kCaption];
    [encoder encodeInteger:self.dislikes forKey:kDislikes];
    [encoder encodeInteger:self.frameRate forKey:kFrameRate];
    [encoder encodeInteger:self.gfyNumber forKey:kGfyNumber];
    [encoder encodeObject:self.categories forKey:kCategories];
    [encoder encodeInteger:self.likes forKey:kLikes];
    [encoder encodeObject:self.md5 forKey:kMd5];
    [encoder encodeBool:self.nsfw forKey:kNsfw];
    [encoder encodeInteger:self.numberOfFrames forKey:kNumberOfFrames];
    [encoder encodeBool:self.published forKey:kPublished];
    [encoder encodeObject:self.tags forKey:kTags];
    [encoder encodeObject:self.title forKey:kTitle];
    [encoder encodeObject:self.userName forKey:kUserName];
    [encoder encodeObject:self.userDisplayName forKey:kUserDisplayName];
    [encoder encodeObject:self.userProfileImageUrl forKey:kUserProfileImageUrl];
    [encoder encodeInteger:self.views forKey:kViews];
    
    [encoder encodeInteger:self.sourceType forKey:kSourceType];
    [encoder encodeObject:self.sourceUrl forKey:kSourceUrl];

    [encoder encodeInteger:self.gifSize forKey:kGifSize];
    [encoder encodeInteger:self.mpgSize forKey:kMpgSize];
    [encoder encodeInteger:self.webmSize forKey:kWebmSize];
    
    [encoder encodeObject:self.gifUrl forKey:kGifUrl];
    [encoder encodeObject:self.gif100Url forKey:kGif100Url];
    [encoder encodeObject:self.gif1MbUrl forKey:kGif1MbUrl];
    [encoder encodeObject:self.gif2MbUrl forKey:kGif2MbUrl];
    [encoder encodeObject:self.gif5MbUrl forKey:kGif5MbUrl];

    [encoder encodeObject:self.mpgUrl forKey:kMpgUrl];
    [encoder encodeObject:self.mpg320Url forKey:kMpg320Url];
    [encoder encodeObject:self.mpg640Url forKey:kMpg640Url];
    [encoder encodeObject:self.mjpgUrl forKey:kMjpgUrl];

    [encoder encodeObject:self.posterUrl forKey:kPosterUrl];
    [encoder encodeObject:self.thumbnail100Url forKey:kThumbnail100Url];
    [encoder encodeObject:self.thumbnail320Url forKey:kThumbnail320Url];
    [encoder encodeObject:self.thumbnail640Url forKey:kThumbnail640Url];

    [encoder encodeObject:self.webmUrl forKey:kWebmUrl];
    [encoder encodeObject:self.webpUrl forKey:kWebpUrl];

    [encoder encodeBool:self.hasTransparency forKey:kHasTransparency];
}

#pragma mark - Getters

- (NSURL *)gfyUrl
{
    return _gfyUrl ?: super.gfyUrl;
}

- (NSURL *)gifUrl
{
    return _gifUrl ?: super.gifUrl;
}

- (NSURL *)gif100Url
{
    return _gif100Url ?: super.gif100Url;
}

- (NSURL *)gif1MbUrl
{
    return _gif1MbUrl ?: super.gif1MbUrl;
}

- (NSURL *)gif2MbUrl
{
    return _gif2MbUrl ?: super.gif2MbUrl;
}

- (NSURL *)gif5MbUrl
{
    return _gif5MbUrl ?: super.gif5MbUrl;
}

- (NSURL *)mpgUrl
{
    return _mpgUrl ?: super.mpgUrl;
}

- (NSURL *)mpg320Url
{
    return _mpg320Url ?: super.mpg320Url;
}

- (NSURL *)mpg640Url
{
    return _mpg640Url ?: super.mpg640Url;
}

- (NSURL *)mjpgUrl
{
    return _mjpgUrl ?: super.mjpgUrl;
}

- (NSURL *)posterUrl
{
    return _posterUrl ?: super.posterUrl;
}

- (NSURL *)thumbnail100Url
{
    return _thumbnail100Url ?: super.thumbnail100Url;
}

- (NSURL *)thumbnail320Url
{
    return _thumbnail320Url ?: super.thumbnail320Url;
}

- (NSURL *)thumbnail640Url
{
    return _thumbnail640Url ?: super.thumbnail640Url;
}

- (NSURL *)webmUrl
{
    return _webmUrl ?: super.webmUrl;
}

- (NSURL *)webpUrl
{
    return _webpUrl ?: super.webpUrl;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    GfycatMedia *copy = [super copyWithZone:zone];

    copy.createDate = [self.createDate copyWithZone:zone];
    copy.caption = self.caption;
    copy.dislikes = self.dislikes;
    copy.frameRate = self.frameRate;
    copy.gfyNumber = self.gfyNumber;
    copy.categories = [self.categories copyWithZone:zone];
    copy.likes = self.likes;
    copy.md5 = self.md5;
    copy.nsfw = self.nsfw;
    copy.numberOfFrames = self.numberOfFrames;
    copy.published = self.published;
    copy.tags = [self.tags copyWithZone:zone];
    copy.title = self.title;
    copy.userName = self.userName;
    copy.userDisplayName = self.userDisplayName;
    copy.userProfileImageUrl = self.userProfileImageUrl;
    copy.views = self.views;

    copy.sourceType = self.sourceType;
    copy.sourceUrl = self.sourceUrl;

    copy.gifSize = self.gifSize;
    copy.mpgSize = self.mpgSize;
    copy.webmSize = self.webmSize;

    copy.gifUrl = self.gifUrl;
    copy.gif100Url = self.gif100Url;
    copy.gif1MbUrl = self.gif1MbUrl;
    copy.gif2MbUrl = self.gif2MbUrl;
    copy.gif5MbUrl = self.gif5MbUrl;

    copy.mpgUrl = self.mpgUrl;
    copy.mpg320Url = self.mpg320Url;
    copy.mpg640Url = self.mpg640Url;
    copy.mjpgUrl = self.mjpgUrl;

    copy.posterUrl = self.posterUrl;
    copy.thumbnail100Url = self.thumbnail100Url;
    copy.thumbnail320Url = self.thumbnail320Url;
    copy.thumbnail640Url = self.thumbnail640Url;

    copy.webmUrl = self.webmUrl;
    copy.webpUrl = self.webpUrl;
    
    copy.hasTransparency = self.hasTransparency;

    return copy;
}

@end

#pragma mark - GfycatMediaCollection -

@interface GfycatMediaCollection()

@property (nonatomic) NSString *cursor;
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
                GfycatMedia *media = [[GfycatMedia alloc] initWithInfo:gfycat];
                if (media.gfyId.length && media.gfyName.length && media.size.width && media.size.height) {
                    [array addObject:media];
                } else {
                    NSLog(@"GFYCAT: Skipping invalid media: '%@', gfyName = '%@', size = %@ x %@.", media.gfyId, media.gfyName, @(media.size.width), @(media.size.height));
                }
            }
            self.array = [array copy];
        }
        
        self.cursor = info[kCursor];
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

@implementation GfycatMediaCollectionWithPaginatedInfo

#pragma mark - Equality

- (NSUInteger)hash {
    if (self.paginationInfo) {
        return [super hash] ^ [self.paginationInfo hash];
    }
    return [super hash];
}

- (BOOL)isEqual:(GfycatMediaCollectionWithPaginatedInfo *)collectionWithPaginationInfo {
    if (![collectionWithPaginationInfo isKindOfClass:[GfycatMediaCollectionWithPaginatedInfo class]]) {
        return NO;
    }
    return YES ||
        [super isEqual:collectionWithPaginationInfo] &&
        ((self.paginationInfo == collectionWithPaginationInfo.paginationInfo) ||
         self.paginationInfo && [self.paginationInfo isEqual:collectionWithPaginationInfo.paginationInfo]);
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return [super supportsSecureCoding];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.paginationInfo = [aDecoder decodeObjectOfClass:[GfycatPaginationInfo class] forKey:kPaginationInfo];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    if (self.paginationInfo) {
        [aCoder encodeObject:self.paginationInfo forKey:kPaginationInfo];
    }
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    GfycatMediaCollectionWithPaginatedInfo *copy = [super copyWithZone:zone];
    copy->_paginationInfo = [self.paginationInfo copyWithZone:zone];
    return copy;
}

@end
