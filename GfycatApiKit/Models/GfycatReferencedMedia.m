//
//  GfycatReferencedMedia.m
//  GfycatApiKit
//
//  Created by Voytenko Oleksiy on 6/8/17.
//  Copyright © 2017 Gfycat. All rights reserved.
//

#import "GfycatReferencedMedia.h"
#import "GfycatModelConstants.h"

@interface GfycatReferencedMedia ()

@property (nonatomic, copy) NSString *averageColor;
@property (nonatomic, copy) NSString *gfyName;
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, copy) NSString *caption;
@property (nonatomic, assign) NSInteger dislikes;
@property (nonatomic, assign) NSInteger frameRate;
@property (nonatomic, assign) NSInteger gfyNumber;
@property (nonatomic, strong) NSURL *gfyUrl;
@property (nonatomic, assign) NSInteger gifSize;
@property (nonatomic, strong) NSURL *gifUrl;
@property (nonatomic, strong) NSURL *gif100Url;
@property (nonatomic, strong) NSURL *gif1MbUrl;
@property (nonatomic, strong) NSURL *gif2MbUrl;
@property (nonatomic, strong) NSURL *gif5MbUrl;
@property (nonatomic, strong) NSArray<NSString *> *categories;
@property (nonatomic, assign) NSInteger likes;
@property (nonatomic, copy) NSString *md5;
@property (nonatomic, assign) NSInteger mpgSize;
@property (nonatomic, strong) NSURL *mpgUrl;
@property (nonatomic, strong) NSURL *mpg320Url;
@property (nonatomic, strong) NSURL *mpg640Url;
@property (nonatomic, strong) NSURL *mjpgUrl;
@property (nonatomic, assign, getter=isNsfw) BOOL nsfw;
@property (nonatomic, assign) NSInteger numberOfFrames;
@property (nonatomic, strong) NSURL *posterUrl;
@property (nonatomic, assign, getter=isPublished) BOOL published;
@property (nonatomic, assign) NSInteger sourceType;
@property (nonatomic, strong) NSURL *sourceUrl;
@property (nonatomic, strong) NSArray<NSString *> *tags;
@property (nonatomic, strong) NSURL *thumbnail100Url;
@property (nonatomic, strong) NSURL *thumbnail320Url;
@property (nonatomic, strong) NSURL *thumbnail640Url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) NSInteger views;
@property (nonatomic, assign) NSInteger webmSize;
@property (nonatomic, strong) NSURL *webmUrl;
@property (nonatomic, strong) NSURL *webpUrl;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;

@end

@implementation GfycatReferencedMedia

- (instancetype)initWithMessageURL:(NSURL *)messageURL
{
    if (self = [super init]) {
        NSString *extensionString = [[messageURL.absoluteString componentsSeparatedByString:@"/"] lastObject];
        self.gfyName = [[extensionString componentsSeparatedByString:@"#"] firstObject];
        NSString *parametersString = [[extensionString componentsSeparatedByString:@"#"] lastObject];
        NSMutableDictionary *parameters = [@{} mutableCopy];
        
        for (NSString *pair in [parametersString componentsSeparatedByString:@"&"]) {
            NSString *key = [[pair componentsSeparatedByString:@"="] firstObject];
            NSString *value = [[pair componentsSeparatedByString:@"="] lastObject];
            parameters[key] = value;
        }
        
        self.averageColor = parameters[@"avg"];
        
        CGFloat width = [parameters[@"w"] floatValue];
        CGFloat height = [parameters[@"h"] floatValue];
        self.size = CGSizeMake(width, height);
    }
    
    return self;
}

- (NSURL *)webpUrl
{
    return self.gfyName.length ? [NSURL URLWithString:[NSString stringWithFormat:@"http://thumbs.gfycat.com/%@.webp", self.gfyName]] : nil;
}

- (NSString *)gfyId
{
    return _gfyName.lowercaseString;
}

- (NSURL *)gfyUrl
{
    return self.gfyName.length ? [NSURL URLWithString:[NSString stringWithFormat:@"https://gfycat.com/gifs/detail/%@", self.gfyName]] : nil;
}

- (NSURL *)gifUrl
{
    return self.gfyName.length ? [NSURL URLWithString:[NSString stringWithFormat:@"https://giant.gfycat.com/%@.gif", self.gfyName]] : nil;
}

- (NSURL *)gif100Url
{
    return self.gfyName.length ? [NSURL URLWithString:[NSString stringWithFormat:@"https://thumbs.gfycat.com/%@-100px.gif", self.gfyName]] : nil;
}

- (NSURL *)gif1MbUrl
{
    return self.gfyName.length ? [NSURL URLWithString:[NSString stringWithFormat:@"https://thumbs.gfycat.com/%@-max-1mb.gif", self.gfyName]] : nil;
}

- (NSURL *)gif2MbUrl
{
    return self.gfyName.length ? [NSURL URLWithString:[NSString stringWithFormat:@"https://thumbs.gfycat.com/%@-small.gif", self.gfyName]] : nil;
}

- (NSURL *)gif5MbUrl
{
    return self.gfyName.length ? [NSURL URLWithString:[NSString stringWithFormat:@"https://thumbs.gfycat.com/%@-size_restricted.gif", self.gfyName]] : nil;
}

- (NSURL *)mpgUrl
{
    return self.gfyName.length ? [NSURL URLWithString:[NSString stringWithFormat:@"https://fat.gfycat.com/%@.mp4", self.gfyName]] : nil;
}

- (NSURL *)mpg320Url
{
    return self.gfyName.length ? [NSURL URLWithString:[NSString stringWithFormat:@"https://thumbs.gfycat.com/%@-mini.mp4", self.gfyName]] : nil;
}

- (NSURL *)mpg640Url
{
    return self.gfyName.length ? [NSURL URLWithString:[NSString stringWithFormat:@"https://thumbs.gfycat.com/%@-mobile.mp4", self.gfyName]] : nil;
}

- (NSURL *)mjpgUrl
{
    return self.gfyName.length ? [NSURL URLWithString:[NSString stringWithFormat:@"https://thumbs.gfycat.com/%@.mjpg", self.gfyName]] : nil;
}

- (NSURL *)posterUrl
{
    return self.gfyName.length ? [NSURL URLWithString:[NSString stringWithFormat:@"https://thumbs.gfycat.com/%@-poster.jpg", self.gfyName]] : nil;
}

- (NSURL *)webmUrl
{
    return self.gfyName.length ? [NSURL URLWithString:[NSString stringWithFormat:@"https://zippy.gfycat.com/%@.webm", self.gfyName]] : nil;
}

- (NSURL *)thumbnail100Url
{
    return self.gfyName.length ? [NSURL URLWithString:[NSString stringWithFormat:@"https://thumbs.gfycat.com/%@-thumb100.jpg", self.gfyName]] : nil;
}

- (NSURL *)thumbnail320Url
{
    return self.gfyName.length ? [NSURL URLWithString:[NSString stringWithFormat:@"https://thumbs.gfycat.com/%@-mini.jpg", self.gfyName]] : nil;
}

- (NSURL *)thumbnail640Url
{
    return self.gfyName.length ? [NSURL URLWithString:[NSString stringWithFormat:@"https://thumbs.gfycat.com/%@-mobile.jpg", self.gfyName]] : nil;
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
    GfycatReferencedMedia *copy = [super copyWithZone:zone];
    
    copy.averageColor = [self.averageColor copy];
    copy.createDate = [self.createDate copy];
    copy.caption = [self.caption copy];
    copy.dislikes = self.dislikes;
    copy.frameRate = self.frameRate;
    copy.gfyName = [self.gfyName copy];
    copy.gfyNumber = self.gfyNumber;
    copy.gifSize = self.gifSize;
    copy.gifUrl = [self.gifUrl copy];
    copy.gif100Url = [self.gif100Url copy];
    copy.gif1MbUrl = [self.gif1MbUrl copy];
    copy.gif2MbUrl = [self.gif2MbUrl copy];
    copy.gif5MbUrl = [self.gif5MbUrl copy];
    copy.height = self.height;
    copy.categories = [self.categories copy];
    copy.likes = self.likes;
    copy.md5 = [self.md5 copy];
    copy.mpgSize = self.mpgSize;
    copy.mpgUrl = [self.mpgUrl copy];
    copy.mpg320Url = [self.mpg320Url copy];
    copy.mpg640Url = [self.mpg640Url copy];
    copy.mjpgUrl = [self.mjpgUrl copy];
    copy.nsfw = self.nsfw;
    copy.numberOfFrames = self.numberOfFrames;
    copy.posterUrl = [self.posterUrl copy];
    copy.published = self.published;
    copy.sourceType = self.sourceType;
    copy.sourceUrl = [self.sourceUrl copy];
    copy.tags = [self.tags copy];
    copy.thumbnail100Url = [self.thumbnail100Url copy];
    copy.thumbnail320Url = [self.thumbnail320Url copy];
    copy.thumbnail640Url = [self.thumbnail640Url copy];
    copy.title = [self.title copy];
    copy.userName = [self.userName copy];
    copy.views = self.views;
    copy.webmSize = self.webmSize;
    copy.webmUrl = [self.webmUrl copy];
    copy.webpUrl = [self.webpUrl copy];
    copy.width = self.width;
    
    return copy;
}


@end
