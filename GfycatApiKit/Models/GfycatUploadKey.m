//
//  GfycatUploadKey.m
//  GfycatApiKit
//
//  Created by Yin Zhu on 3/14/17.
//  Copyright © 2017 Gfycat. All rights reserved.
//

#import "GfycatUploadKey.h"
#import "GfycatModelConstants.h"
#import "GfycatApiConstants.h"

@interface GfycatUploadKey ()

@property (nonatomic, copy) NSString *secret;

@end

@implementation GfycatUploadKey

- (instancetype)initWithInfo:(NSDictionary *)info {
    NSString *gfycatUploadName = GfyNotNull(info[kGfycatUploadName]) ? [[NSString alloc] initWithString:info[kGfycatUploadName]] : @"";
    NSDictionary *dictionary = @{kGfyId:gfycatUploadName};
    
    self = [super initWithInfo:dictionary];
    if (self && GfyNotNull(info)) {
        self.secret = GfyNotNull(info[kGfycatUploadSecret]) ? [[NSString alloc] initWithString:info[kGfycatUploadSecret]] : nil;
    }
    return self;
}

#pragma mark - Equality

- (BOOL)isEqualToModel:(GfycatUploadKey *)uploadKey {
    return [super isEqualToModel:uploadKey] && [self.secret isEqualToString:uploadKey.secret];
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super initWithCoder:decoder])) {
        self.secret = [decoder decodeObjectOfClass:[NSString class] forKey:kGfycatUploadSecret];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:self.secret forKey:kGfycatUploadSecret];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    GfycatUploadKey *copy = [super copyWithZone:zone];
    
    copy->_secret = [self.secret copy];
    
    return copy;
}

@end


