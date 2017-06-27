//
//  GfycatReferencedMedia.m
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

#import "GfycatReferencedMedia.h"
#import "GfycatModelConstants.h"
#import "GfycatApiConstants.h"
#import "NSDictionary+GfycatApiKit.h"

@interface GfycatReferencedMedia ()
{
    NSInteger _width;
    NSInteger _height;
}

@end

@implementation GfycatReferencedMedia

@synthesize size = _size;

- (nullable instancetype)initWithMessageURL:(NSURL *)messageURL
{
    if (![messageURL.host isEqualToString:@"gfycat.com"] && ![messageURL.host isEqualToString:@"www.gfycat.com"]) {
        return nil;
    }
    
    NSString *extensionString = [[messageURL.absoluteString componentsSeparatedByString:@"/"] lastObject];
    NSString *gfyName = [[extensionString componentsSeparatedByString:@"#"] firstObject];
    NSString *gfyId = [[[extensionString componentsSeparatedByString:@"#"] firstObject] lowercaseString];

    if (GfyNotNull(gfyId) && (self = [super initWithGfyId:gfyId])) {
        
        _gfyName = gfyName;
        NSString *parametersString = [[extensionString componentsSeparatedByString:@"#"] lastObject];
        NSMutableDictionary *parameters = [@{} mutableCopy];
        
        for (NSString *pair in [parametersString componentsSeparatedByString:@"&"]) {
            NSString *key = [[pair componentsSeparatedByString:@"="] firstObject];
            NSString *value = [[pair componentsSeparatedByString:@"="] lastObject];
            parameters[key] = value;
        }
        
        _averageColor = parameters[@"avg"] ?: @"000000";
        _width = [parameters[@"w"] floatValue] ?: 100;
        _height = [parameters[@"h"] floatValue] ?: 100;
    }
    
    return self;
}

- (instancetype)initWithInfo:(NSDictionary *)info {
    self = [super initWithInfo:info];
    if (self && GfyNotNull(info)) {
        NSMutableDictionary *gfyItem = GfyNotNull(info[kGfyItem]) ? info[kGfyItem] : info;
        
        _averageColor = [gfyItem gfy_stringValueForKey:kAverageColor];
        _gfyName = [gfyItem gfy_stringValueForKey:kGfyName];
        _width = [gfyItem gfy_integerValueForKey:kWidth];
        _height = [gfyItem gfy_integerValueForKey:kHeight];
    }
    return self;
}

- (CGSize)size {
    if (CGSizeEqualToSize(_size, CGSizeZero)) {
        _size = CGSizeMake(_width, _height);
    }
    
    return _size;
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

- (NSURL *)webmUrl
{
    return self.gfyName.length ? [NSURL URLWithString:[NSString stringWithFormat:@"https://zippy.gfycat.com/%@.webm", self.gfyName]] : nil;
}

- (NSURL *)webpUrl
{
    return self.gfyName.length ? [NSURL URLWithString:[NSString stringWithFormat:@"http://thumbs.gfycat.com/%@.webp", self.gfyName]] : nil;
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super initWithCoder:decoder])) {
        _gfyName = [decoder decodeObjectOfClass:[NSString class] forKey:kGfyName];
        _averageColor = [decoder decodeObjectOfClass:[NSString class] forKey:kAverageColor];
        _width = [decoder decodeIntegerForKey:kWidth];
        _height = [decoder decodeIntegerForKey:kHeight];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:self.gfyName forKey:kGfyName];
    [encoder encodeObject:self.averageColor forKey:kAverageColor];
    [encoder encodeInteger:self.size.width forKey:kWidth];
    [encoder encodeInteger:self.size.height forKey:kHeight];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    GfycatReferencedMedia *copy = [super copyWithZone:zone];
    
    copy->_gfyName = [self.gfyName copyWithZone:zone];
    copy->_averageColor = [self.averageColor copyWithZone:zone];
    copy->_width = _width;
    copy->_height = _height;
    
    return copy;
}


@end
