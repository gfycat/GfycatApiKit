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
        self.averageColor = [decoder decodeObjectForKey:kColor];
        self.gfyName = [decoder decodeObjectForKey:kGfyName];
        self.size = CGSizeMake([decoder decodeIntegerForKey:kWidth], [decoder decodeIntegerForKey:kHeight]);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
    
    [encoder encodeInteger:self.size.width forKey:kWidth];
    [encoder encodeInteger:self.size.height forKey:kHeight];
    [encoder encodeObject:self.averageColor forKey:kColor];
    [encoder encodeObject:self.gfyName forKey:kGfyName];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    GfycatReferencedMedia *copy = [super copyWithZone:zone];
    
    copy->_averageColor = self.averageColor;
    copy->_gfyName = self.gfyName;
    copy->_size = self.size;
    
    return copy;
}


@end
